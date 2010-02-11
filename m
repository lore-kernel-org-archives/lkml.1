Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab0BKWsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:48:07 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55632 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab0BKWsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:48:05 -0500
To: Greg KH <gregkh@suse.de>
Cc: Neil Brown <neilb@suse.de>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate  between locking links and non-links
References: <19314.1869.847327.15190@notabene.brown>
	<20100210230625.GB678@suse.de> <m1fx57zbyl.fsf@fess.ebiederm.org>
	<20100211223235.GC30430@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 11 Feb 2010 14:47:57 -0800
In-Reply-To: <20100211223235.GC30430@suse.de> (Greg KH's message of "Thu\, 11 Feb 2010 14\:32\:35 -0800")
Message-ID: <m1bpfvz8wy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Thu, Feb 11, 2010 at 01:42:10PM -0800, Eric W. Biederman wrote:
>> Greg KH <gregkh@suse.de> writes:
>> 
>> > On Wed, Feb 10, 2010 at 12:09:33PM +1100, Neil Brown wrote:
>> >> 
>> >> Hi,
>> >>  I've just spent a while sorting out some lockdep complaints triggered
>> >>  by the recent addition of the "s_active" lockdep annotation in sysfs
>> >>   (commit 846f99749ab68bbc7f75c74fec305de675b1a1bf)
>> >> 
>> >>  Some of them are genuine and I have submitted a fix for those.
>> >>  Some are, I think, debatable and I get to that is a minute.  I've
>> >>  submitted a fix for them anyway.
>> >>  But some are to my mind clearly bogus and I'm hoping that can be
>> >>  fixed by the change below (or similar).
>> >>  The 'bogus' ones are triggered by writing to a sysfs attribute file
>> >>  for which the handler tries to delete a symlink from sysfs.
>> >>  This appears to be a recursion on s_active as s_active is held while
>> >>  the handler runs and is again needed to effect the delete.  However
>> >>  as the thing being deleted is a symlink, it is very clearly a
>> >>  different object to the thing triggering the delete, so there is no
>> >>  real loop.
>> >> 
>> >>  The following patch splits the lockdep context in two - one for
>> >>  symlink and one for everything else.  This removes the apparent loop.
>> >>  (An example report can be seen in
>> >>      http://bugzilla.kernel.org/show_bug.cgi?id=15142).
>> >> 
>> >>  The "debatable" dependency loops happen when writing to one attribute
>> >>  causes a different attribute to be deleted.  In my (md) case this can
>> >>  actually cause a deadlock as both the attributes take the same lock
>> >>  while the handler is running.  This is because deleting the attribute
>> >>  will block until the all accesses of that attribute have completed (I
>> >>  think).
>> >>  However it should be possible to delete a name from sysfs while there
>> >>  are still accesses pending (it works for normal files!!).  So if
>> >>  sysfs could be changed to simply unlink the file and leave deletion to
>> >>  happen when the refcount become zero it would certainly make my life
>> >>  a lot easier, and allow the removal of some ugly code from md.c.
>> >>  I don't know sysfs well enough to suggest a patch though.
>> >> 
>> >> Thanks,
>> >> NeilBrown
>> >> 
>> >> 
>> >> 
>> >> commit 2e502cfe444b68f6ef6b8b2abe83b6112564095b
>> >> Author: NeilBrown <neilb@suse.de>
>> >> Date:   Wed Feb 10 09:43:45 2010 +1100
>> >> 
>> >>     sysfs: differentiate  between locking links and non-links for sysfs
>> >>     
>> >>     symlinks and non-symlink is sysfs are very different.
>> >>     A symlink can never be locked (active) while an attribute
>> >>     modification routine is running.  So removing symlink from an
>> >>     attribute 'store' routine should be permitted without any lockdep
>> >>     warnings.
>> >>     
>> >>     So split the lockdep context for 's_active' in two, one for symlinks
>> >>     and other for everything else.
>> >>     
>> >>     Signed-off-by: NeilBrown <neilb@suse.de>
>> >
>> > Nice patch, I'll queue it up for .34.
>> 
>> Note the patch does not compile with lockdep disabled.
>
> Ugh, why not?
>
> Neil, care to fix this up?

 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define sysfs_dirent_init_lockdep(sd)				\
+#define sysfs_dirent_init_lockdep(sd, type)			\
 do {								\
 	static struct lock_class_key __key;			\
 								\
-	lockdep_init_map(&sd->dep_map, "s_active", &__key, 0);	\
+	lockdep_init_map(&sd->dep_map, "s_active_" type, &__key, 0);	\
 } while(0)
 #else
 #define sysfs_dirent_init_lockdep(sd) do {} while(0)
                                     ^^^^

Eric



