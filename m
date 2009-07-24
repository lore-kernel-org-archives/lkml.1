Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbZGXUub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbZGXUub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZGXUua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:50:30 -0400
Received: from mail.lang.hm ([64.81.33.126]:33751 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbZGXUu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:50:29 -0400
Date: Fri, 24 Jul 2009 13:48:43 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, jengelh@medozas.de, aviro@redhat.com,
       mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in, pavel@suse.cz
Subject: Re: fanotify - overall design before I start sending patches
In-Reply-To: <1248466429.3567.82.camel@localhost>
Message-ID: <alpine.DEB.1.10.0907241340580.28013@asgard.lang.hm>
References: <1248466429.3567.82.camel@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

getting an open fd to the file is good for things like content scanning, 
but for other things like a HSM re-populating the file, you would need to 
pass the path used to open the file at open time. is this in the metadata 
you are passing?

this currently does not give you a good way to listen for info on a 
specific directory tree, you imply at the end that you could go global, 
but without a path (which you will not have in some cases) it's impossible 
to decide if you care about this file or not.

to avoid race conditions, you may want some way that a listener on a 
directory can flag that it wants to also be a listener for all new 
directories created under the one it is listening on.

with the PERM checks, can a checker respond within the 5 second window 
with 'I need more time'? or does it need to complete all it's work in <5 
seconds?

David Lang


On Fri, 24 Jul 2009, Eric Paris wrote:

> I plan to start sending patches for fanotify in the next week or two.
> I'd like to see more comments on the design, interface, and capabilities
> in case there is a recognized need for major reworks or if I'm not
> meeting some users needs (other than those noted at the end)
>
> git://git.infradead.org/users/eparis/notify.git fanotify-experimental
>
> should have working code to test what I'm talking about.
>
> What is fanotify?
>
> It is a new notification system that has a limited set of events (open,
> close, read, write) in which notification not only comes with metadata
> the describes what happened it also comes with an open file descriptor
> to the object in question.  fanotify will also allow the listener to
> make access decisions on open and read events.  This allows the
> implementation of hierarchical storage management systems or an access
> file scanning or integrity checking.
>
> fanotify comes in two flavors 'directed' and 'global.'  'Directed' is
> like inotify or dnotify in that you register specific inodes of interest
> and only get events pertaining to those inodes.  Global means you are
> registering interest for event types system wide.  With global mode the
> listener program can later exclude objects from future events.
>
> fanotify kernel/userspace interaction is over a new socket protocol.  A
> listener opens a new socket in the new PF_FANOTIFY family.  The socket
> is then bound to an address.  Using the following struct:
>
> struct fanotify_addr {
>        sa_family_t family;
>        __u32 priority;
>        __u32 group_num;
>        __u32 mask;
>        __u32 f_flags;
>        __u32 unused[16];
> }  __attribute__((packed));
>
> The priority field indicates in which order fanotify listeners will get
> events.  Since 2 fanotify listeners would 'hear' each others events on
> the new fd they create fanotify listeners will not hear events generated
> by other fanotify listeners with a lower priority number.
>
> The group_num is at the moment not used, but the plan was to allow 2
> processes to bind to the same fanotify group and share the load of
> processing events.
>
> The f_flags is the flags which the fanotify listener wishes to use when
> opening their notification fds.  On access scanners would want to use
> O_RDONLY, whereas HSM systems would need to use O_WRONLY.
>
> The mask is the indication of the events this group is interested in.
> The set of events of interest if FAN_GLOBAL_LISTENER is set at bind
> time.  If FAN_GLOBAL_LISTENER is not set, this field is meaningless as
> the registration of events on individual inodes will dictate the
> reception of events.
>
> * FAN_ACCESS: every file access.
> * FAN_MODIFY: file modifications.
> * FAN_CLOSE: files are closed.
> * FAN_OPEN: open() calls.
> * FAN_ACCESS_PERM: like FAN_ACCESS, except that the process trying to
> access the file is put on hold while the fanotify client decides whether
> to allow the operation.
> * FAN_OPEN_PERM: like FAN_OPEN, but with the permission check.
> * FAN_EVENT_ON_CHILD: receive notification of events on inodes inside
> this subdirectory. (this is not a full recursive notification of all
> descendants, only direct children)
> * FAN_GLOBAL_LISTENER: notify for events on all files in the system.
> * FAN_SURVIVE_MODIFY: special flag that ignores should survive inode
> modification.  Discussed below.
>
> After the socket is bound events are attained using the read() syscall
> (recv* probably also works haven't tested).  This will result in the
> buffer being filled with one or more events like this:
>
> struct fanotify_event_metadata {
>        __u32 event_len;
>        __s32 fd;
>        __u32 mask;
>        __u32 f_flags;
>        __s32 pid;
>        __s32 tgid;
>        __u64 cookie;
> }  __attribute__((packed));
>
> fd specifies the new file descriptor that was created in the context of
> the listener.  (readlink of /proc/self/fd will give you A pathname)
> mask indicates the events type (bitwise OR of the event types listed
> above).  f_flags here is the f_flags the ORIGINAL process has the file
> open with.  pid and tgid are from the original process.  cookie is used
> when the listener needs to allow, deny, or delay the operation.
>
> If a FAN_ACCESS_PERM or FAN_OPEN_PERM event is received the listener
> must send a response before the 5 second timeout.  If no response is
> sent before the 5 second timeout the original operation is allowed.  If
> this happens too many times (10 in a row) the fanotify group is evicted
> from the kernel and will not get any new events.  Sending a response is
> done using the setsockopt() call with the socket options set to
> FANOTIFY_ACCESS_RESPONSE.  The buffer should contain a structure like:
>
> struct fanotify_so_access {
>        __u64 cookie;
>        __u32 response;
> }  __attribute__((packed));
>
> Where cookie is the cookie from the notification and response is one of:
>
> FAN_ALLOW: allow the original operation
> FAN_DENY: deny the original operation
> FAN_RESET_TIMEOUT: reset the timeout.
>
> The last main interface is the 'marking' of inodes.  The purpose of
> inode marks differ between 'directed' and 'global' listeners.  Directed
> fanotify listeners need to mark inodes of interest.  They do that also
> using setsockopt() of type FANOTIFY_SET_MARK with the buffer containing
> a structure like:
>
> struct fanotify_so_inode_mark {
>        __s32 fd;
>        __u32 mask;
>        __u32 ignored_mask;
> }  __attribute__((packed));
>
> Where fd is backed by the inode in question.  Mask is the events of
> interest (only used in directed mode) and ignored_mask is the mask of
> events which should be ignored.
>
> The ignored_mask is cleared every time an inode receives a modification
> events unless FAN_SURVIVE_MODIFY is also set.  The ignored_mask is
> mainly used for 2 purposes.  Global listeners may just have no interest
> in lots of events, so they should spam inodes with an ignored mask.  The
> ignored mask is also used to 'cache' access decisions.  If the listener
> sets FAN_ACCESS_PERM in the ignored mask all access operations will be
> permitted without the call out to userspace.  If the inode is modified
> the ignored_mask will be cleared and userspace will again have to
> approve the access.  If userspace REALLY doesn't care ever they can use
> the special FAN_SURVIVE_MODIFY flag inside the ignored_mask.
>
> The only other current interface is the ability to ignore events by
> superblock magic number.  This makes it easy to ignore all events
> in /proc which can be difficult to accomplish firing FANOTIFY_SET_MARK
> with ignored_masks over and over as processes are created and destroyed.
>
> ***********
>
> Future direction:
> There are 2 things I'm interested in adding.
> - Rename events.
> 	The updatedb/mlocate people are interested in fanotify as a means to
> not thrash the harddrive every night.  They could instead update the db
> in real time as files are moved.
>
> - subtree notification.
> 	Currently to only watch /home and all of it's descendants one must
> either register a directed watch on every directory or use a global
> listener.  The global listener with ignored_mask is not as bad as it
> sounds in my testing, but decent subtree registration and notification
> would be a big win in a lot of people's mind.
>
> ***********
>
> Please, complaints? sortcomings? design flaws?  issues?  failures?  How
> can it be tweaked to suit your needs?
>
> -Eric
>
>
