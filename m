Return-Path: <linux-kernel-owner+w=401wt.eu-S1946183AbXBPSL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946183AbXBPSL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946184AbXBPSL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:11:56 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35950 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946183AbXBPSLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:11:55 -0500
Date: Fri, 16 Feb 2007 20:59:01 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Michael Holzheu <holzheu2@linux.vnet.ibm.com>, akpm@osdl.org,
       mschwid2@de.ltcfwd.linux.ibm.com, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Using kevent for event logging?
Message-ID: <20070216175900.GA21522@2ka.mipt.ru>
References: <20070216155708.589cd47a.holzheu2@linux.vnet.ibm.com> <20070216150618.GA25878@2ka.mipt.ru> <200702161833.35710.holzheu@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200702161833.35710.holzheu@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 16 Feb 2007 20:59:07 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 06:33:35PM +0100, Michael Holzheu (holzheu@linux.vnet.ibm.com) wrote:
> Hi Evgeniy,

Hi Michael.

> On Friday 16 February 2007 16:06, Evgeniy Polyakov wrote:
> > On Fri, Feb 16, 2007 at 03:57:08PM +0100, Michael Holzheu (holzheu2@linux.vnet.ibm.com) wrote:
> > 
> > You will need to have implemented two types of operations - userspace
> > daemon, which will request some notifications (i.e. notify me when event
> > type:1, event:2 is ready), and that one which will mark such requests as
> > ready.
> > 
> > For exactly your purpose I would use userspace kevent notifications - 
> > although in documentation I say that such notifications can be
> > marked from userspace, you can mark them as ready from kernel too
> > (obviously, since kevent is kernel mechanism).
> > 
> > You can also create own kevent notification type and storage (userspace
> > notification requests are stored in the main kevent queue (kevent_user))
> > and compile them only for s390 arch and thus do not overlap with
> > possible usage of userspace notifications.
> 
> Do you think that the following could work?
> 
> We create a new notification type, e.g. KEVENT_S390_LOG, which is
> registered with kevent_add_callbacks(). Something like:
> 
> struct kevent_callbacks sc = {
> 	.callback = &kevent_s390_log_callback,
> 	.enqueue = &kevent_s390_log_enqueue,
> 	.dequeue = &kevent_s390_log_dequeue,
> 	.flags = 0,
> };
> kevent_storage_init(NULL, &log_st);
> kevent_add_callbacks(&sc, KEVENT_S390_LOG);
> 
> Then we have a new kernel event function:
> 
> void kevent_s390_log_notify(u32 event)
> {
> 	kevent_storage_ready(&log_st, NULL, event);
> }
> 
> For each possible event, we define an unique event ID, which can be
> requested by the userspace daemon. E.g.:
> #define KEVENT_S390_TAPE_LOADED 0x00000001
> #define KEVENT_S390_TAPE_UNLOADED 0x00000002
> 
> To create an event in the kernel, the notify function is used. E.g.:
> kevent_s390_log_notify(KEVENT_S390_TAPE_LOADED);
>
> Each event gets a sequence number, which has to be included somehow
> in the kevent (ret_data field?). The event data (e.g. Device number of
> the tape drive) has to be stored probably in some additional wraparound
> buffer, maybe using relay or something similar.
> 
> The userspace daemon basically does the following:
> 
> * Register with kevent_ctl() for all interesting events using the unique
>   event ID
> * Implement kevent_wait()/kevent_commit() loop to get the kernel events
> * The Sequence number of each event can be obtained from the ret_data
>   field (?)
> * The Sequence number can be used to get event data via a second
>   kernel interface (using relay or whatever).
> 
> Does this sound reasonable?

It does, but I want to clarify couple of mements.

1. ret_data is supposed to be used by underlying kevent storages
whenever they like, so it is valid to put there device id or anything
else.
2. note that kevents are never generated at all - usage model requires
userspace to request some set of interests (lie notify me when tape 1 is
loaded or unloaded, notify when something has happend, when data has
arrived and the like), and kernel allows to mark any events as ready.
So if there are two tape devices and userspace asks 'notify me when tape
is loaded' and both tapes are loaded, kevent_s390_something_callback()
will be called twice, but for the same kevent - since userspace only
provided one request type - 'notify me about loded tape', so userspace
will read back kevent only once.

To get different kevents for both tapes two kevents must be provided
with different ids (but the same event number and type), and
kevent_s390_callback (which is called for each kevent in the active
kevent storage - for example in the driver for tape device) must itself
differentiate between marked as ready kevent and empty one.

So briefly drawing:

1. for example tape driver acts as a kevent storage for type 0x1.
2. userspace requests two kevents with id 0x100 and 0x200 with event type:
0x1 (tape event) and event 0x99 (tape is added)
3. user adds a tape, so driver notifies its storage with
kevent_notify_s390_tape(TAPE_EVENT (0x1), TAPE_ADDED (0x99)) - all kevents 
wich have the same (it can be a mask of different events) events are
called - kevent_s390_callback() is invoked for kevent with id 0x100
and (if there is a flag notify all) 0x200.
4. callback copies device id into ret_data for kevent with 0x100 and
returns positive value and sets some flag in private are to show that
this device has been reported
5. callback for kevent 0x200 sees that and return 0
or better do not set wake_all flag, so above steps will be done
automatically, in that case callback must check if kevent is ready and
return 0 in that case
6. userspace can read ready kevent 0x100
7. user adds another tape so we go to step 3 - things will be repeated,
but kevent 0x100 will be skipped (although callback will be invoked for
that kevent too).

It is possible (depending on callback written) that the same kevent
0x100 will be marked as ready again (if userspace has read it already).

> Michael

-- 
	Evgeniy Polyakov
