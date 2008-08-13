Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYHMW5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYHMW5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 18:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYHMW5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 18:57:44 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:29851 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYHMW5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 18:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Cp3Or0O7KEtRHuAo2tZuj4/SOjElr65oaKjYVhpO8ITTNYFf/UANPzcUxALXmWXeSa
         Or1cyyG3PPbIs6XGQSdwQbkUNbUoGQLvoQzHvgpozh15ZNF27hpgNh5ffU/ElkJTyRd/
         V9xambPGpBevMeI0doVY4U3ED3qLiCLXrGjoo=
Message-ID: <e7d8f83e0808131557m7e30b2cj5cf140c8432d17bb@mail.gmail.com>
Date: Thu, 14 Aug 2008 08:57:40 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH 3/4] integrity: Linux Integrity Module(LIM)
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, "Mimi Zohar" <zohar@us.ibm.com>,
       serue@linux.vnet.ibm.com, "James Morris" <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Randy Dunlap" <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       sailer@watson.ibm.com, "Stephen Smalley" <sds@tycho.nsa.gov>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Mimi Zohar" <zohar@linux.vnet.ibm.com>
In-Reply-To: <20485.1218636713@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080808184349.999902616@linux.vnet.ibm.com>
	 <20080809185340.GC22905@infradead.org>
	 <OF0AEBDCA2.1E27B823-ON852574A1.000FEE48-852574A1.004C3185@us.ibm.com>
	 <20080811170255.GA2662@us.ibm.com>
	 <OFAC0E3107.C68382CD-ON852574A2.0068E1AD-852574A2.00692623@us.ibm.com>
	 <20080811195645.GA16685@us.ibm.com>
	 <e7d8f83e0808120141s4a0561fdw4919ce6f74d211af@mail.gmail.com>
	 <20080812192925.GC18034@infradead.org>
	 <e7d8f83e0808130344x29fcb9aja00ce3f64a95ef7b@mail.gmail.com>
	 <20485.1218636713@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 12:11 AM, David Howells <dhowells@redhat.com> wrote:
> Peter Dolding <oiaohm@gmail.com> wrote:
>
>> Credentials patch for Linux allows more than the BSD one does.  Linux one is
>> a complete permission storage replacement.
>
> No, it isn't.  It replaces the permission storage facility of a process but
> does not change the way in which an inode caches its credentials in RAM.
>
>> http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-08/msg02682.html
>>
>> Note the file credentials one.
>
> I said "Open file credentials".  I was referring to struct file which
> designates an open file handle, not the file/inode itself.  What this means is
> that the open file handle takes a reference to the subjective security context
> of the process that opened it, at the time it opened it, so that accesses to
> that file are (with exceptions) done with those credentials, no matter who is
> actually using the handle.
>
> For disk filesystems, for the most part, this makes no difference: an open file
> is usable by anyone who has the handle.  However, for network filesystems,
> where each request is marked with the details of who the request should be
> accounted to and the server decides, it does matter.
>
>> That is reused by FS Cache and it creates fake inodes.
>
> FS-Cache+CacheFiles doesn't create fake inodes at all.  It creates real inodes
> on disk in the cache.  The reason for these patches is that CacheFiles needs to
> use its own subjective security context when creating or accessing these
> inodes, rather than the subjective context of whoever invoked AFS or NFS, and
> thus caused CacheFiles to touch the cache.
>
Source of Inodes is different.   Old style attack aganst AV's has been
to get them to approve something then swap the contents while its
still approved.  Simplest is cache attacking.   We need to single up
the cache with secuirty around it.

Other cache that has been targeted is the swapfile.  Since its another
cache.   Building solid intergeity its key to get control of the
caches.

>> "vfs_permission and file_permission are just small wrappers around
>> inode_permission."  No longer both go to inote_permission after the
>> credentials patch is in.   file_permission instead goes to credentials
>> struct connected to the inode.  Most calls to inode_permission end up
>> wrapped to the credentials struct.
>
> I don't understand what you're talking about.  Looking in fs/namei.c, I see:
>
>        int vfs_permission(struct nameidata *nd, int mask)
>        {
>                return inode_permission(nd->path.dentry->d_inode, mask);
>        }
>
> And:
>
>        int file_permission(struct file *file, int mask)
>        {
>                return inode_permission(file->f_path.dentry->d_inode, mask);
>        }
>
> That looks like they still both go to inode_permission().

Hmm I had redirect file_permission in my own working tree.  Experiment
in reduced storage in the inode and credentionals  systems.

If you look at inode in operation you might as well call the file
permissions on a per file base.  All found so far are the pointer to
the same struct if its exactly the same file.

Its a point of duplication of storage.  Credentials and inode storing it.

Ie file permissions only stored once.
>> Basically by the way Linux Credentials patch is being done.
>> inode_permission could completely cease to exist.    Completely
>> replaced by the credentials structure.
>
> Erm...  Why?  inode_permission() is a function, the creds struct is a data
> type.
>
>> Each filesystem having its own cache is one reason why Linux Credentials
>> Patch is being brought into live.
>
> Not as far as I know.  The credentials belonging to the filesystem and the
> inodes in the filesystem belong to the filesystem and are not held in cred
> structs.  Using cred structs for inodes would waste memory as a task's
> credentials have a lot of bits an inode's don't.
>
>> So a single cache can store all the need information of the OS and for the
>> file system.  Even better operate on filesystems lacking all the need
>> permission structs using a userspace program to fill in some of the blanks.
>>
>> LSM's in Credentials can there own protected data sets since all
>> alterations to Credentials by the user space deamon have to go past
>> LSM for approval or rejection.  Linux Credentials only need a extra
>> protected zone added to cover you LIM needs and AV needs to store
>> data.
>
> Are you suggesting the offloading of security data caching to userspace?

Not for caching mainly.  For some operations intergretiy might be
chosen to be done in user space like if file is signed or not.   Like
checking just using userspace drivers.   Remember you can already
insert userspace drivers in theory for testing of a TPM setup running
from userspace in a small section of the OS could be useful to make
sure everything is right before making active.

Strict interface allowing sections of the security system to operate
in user space and kernel space.  For allowing existence of a combined
defence.

AV program may be approved to set X integrity data in credentials.

Signature checking program might set a flag to say that a application
should never run as root or that its a particular class of
application.   Triggering the LSM to auto reduce applications that
programs system access to match its settings.   For this to be
possible we need secuirty that only the Signature checking program can
set the signature flags.  Then the LSM can trust and repond to them.
 This is bring ipset's style for firewalls http://ipset.netfilter.org/
 to the main secuirty system.

Having both kernel and usermode existing in secuirty has the same
advantage as allowing user mode drivers.  The userspace to be
changeable with threats and independent to kernel.

Most creative expands I am looking into.

Giving Linux equal to layor 7 file wall filtering on the filesystem
level.  file id magics run on file when before the file is opened by
the application that information stored in credentials.   If a program
is no meant to open that file type it can be gets blocked.  When
running anti-virus and many filemangers side by side they don't need
to run magics repetitively.

Final one is a new form of file interlink.  Bit like streams in NTFS.
So thumbnails and the like of images used by filemanagers are
connected to there related file.   So when deleting the file a thumb
nail was created from the thumbnail gets removed.   Hopefully allowing
applications to save on down scaling as well.

Yes I am really messing around in the current internal structs.  To
hopefully provide a framework to archive the max secuirty creatable.
As well as reducing duplication.  So price of doing MAX should be
quite min.
>
>> In simple terms permissions stored in inodes is basically deprecated
>> by Linux's Credentials patch.
>
> In simple terms, no they aren't.

>From the way I am doing it.  Storing shared permissions between files
it is deprecated for the inodes stuct.  Since I altered the code to
move that into credentials alone.   I was thinking too much in my
working tree.
>
>> Sorting out the Credentials patch is kinda key.   Nothing you AV or
>> Integrity people is strange to the Linux Credentials patch.   Without
>> embracing requires more processing when pulling data from a common
>> cache that has already been AV or Integrity scanned and maintained in
>> that state.  Now its really designing the struct that should exist in
>> Credentials.
>
> From my quick glance over the integrity patches, I'd say that the cred struct
> is entirely the wrong place to store this data.  It's nothing to do with a
> task's subjective state, except, perhaps, in setting it up.  It appears to be
> per-inode state.
>

Its the  in operation of the LIM.   Same as AV.  Complete files will
be scanned.  Passed or failed or marked unknown.   Currently we have
nice duplication of lots of things.  Its been the alteration in my
working tree that has given me  major different look at how to do
this.    I am trying to get to a location where there is no
duplication of permission storage or caching.   Simpler to audit
system access 1 struct know operational and real storage state.

Peter Dolding
