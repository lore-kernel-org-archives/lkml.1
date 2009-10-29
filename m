Return-Path: <linux-kernel-owner+w=401wt.eu-S1750898AbZJ2ENV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898AbZJ2ENV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 00:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbZJ2ENV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 00:13:21 -0400
Received: from smtp107.prem.mail.sp1.yahoo.com ([98.136.44.62]:23404 "HELO
	smtp107.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750716AbZJ2ENU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 00:13:20 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: .l7MYNQVM1k6i7g0qGsydXYhSgyUHvDKHfZg.5PFUq56GvhyxN.qbV9xic6vUP1Uci8YZf4L1IpDQuUyRrYLxIF6i1Lre6yHL_UDF9vf5U2ceNjEGWCOZuM3LVn_96qhaVBAasItmMNA7Afx7tdcRFvGywL1bDJcx8sKXXSR_yXbcAXqQoTa6TO_CxdmHbgg5BO7UP8FotbNAMY.2sg4DWWNAX9Xh_d2CedQZF72HFlkShfHEr7qrj18..hZzlZtIGPVfJWCwM1TaXEI1qnUoS9nBzmyzId664CsguAll58frkxF47gkT34-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AE91658.9090105@schaufler-ca.com>
Date: Wed, 28 Oct 2009 21:13:12 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: David Wagner <daw-news@cs.berkeley.edu>
CC: linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: symlinks with permissions
References: <20091025062953.GC1391@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org> <20091028081653.GA18290@elf.ucw.cz> <4AE87292.20802@schaufler-ca.com> <hcahnb$mgp$1@taverner.cs.berkeley.edu>
In-Reply-To: <hcahnb$mgp$1@taverner.cs.berkeley.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wagner wrote:
> Casey Schaufler  wrote:
>   
>> There is no security violation here. Consider the case where
>> the file is unlinked after it is opened. What directory permissions
>> would matter in that case?
>>     
>
> Where are you going with this?
>   

Probably straight into a level of obscurity that only a
very small fraction of us care about, but hear me out.

> Suppose I open a file in read-only mode.  Suppose moreover I only
> have permission to read the file but not write it (given the full
> permissions on the path to the file).

Ok. The parenthetical clause is a problem. Once you have the file
descriptor the path that you used to get it is completely irrelevant.
Not just unimportant. It matters not at all. The only thing that
matters at that point are the mode bits on the file itself. Why?
If /a/foo is a hard link to /b/bar (for the uninitiated that means
that foo and bar are on the same file system and share an inode
number) there is absolutely no way to tell, given a file descriptor,
which path was used to open the file. Further, it is no longer
necessary that foo, bar, a, or b even exist any longer. So if
/proc/8675309/fd/3 is accessable for write access to a process it
does not matter one horse's pitutte what the mode bits on a or b
might be. Period.

>   Suppose that someone else deletes
> the file.  Then the OS had darn well better prevent me from upgrading
> my read-only file descriptor to a read-write file descriptor.

Nope. Not if the mode bits on the file allow it. How you got to
the file matters not at all. The mode of the path you happened to
use matters not at all. What matters are the mode bit on the file
itself.

>   If some
> OS feature created a backdoor that allowed me to upgrade my read-only
> file descriptor to read-write access (even in cases where the file and
> directory permissions would prevent me from directly opening the file in
> read-write mode), then we'd darn well consider that a security violation.
> That is roughly analogous to what is happening here.
>   

No, I don't believe that is correct. Unless I read the discussion
incorrectly, the file has to be writeable for the "exploit" to
work. The reason that it looks like an exploit is that the mode bits
on the containing directory "should" prevent the requested access,
but in reality /proc/8675309/fs/3 provides an alternative pathname
to the object, just as having a hard link or an alternative mount
point might. Neither of those cases is an "exploit", although I can
easily understand how they might appear to be to those who are
unfamiliar with the acyclic graph that is the Linux (Unix) file
system name space.

> I do think Pavel's attack is a security violation.  I don't understand
> why there is any debate about this; it seems pretty clear-cut to me.
> It may be an obscure corner-case, but it still seems like a cut-and-dry
> security violation.  (Incidentally, I found the quality of some of the
> discussion on bugtraq pretty disappointing as well.)
>   

Sorry if my arguments lack clarity. It's been a rough year.

The only access that really matters is that of the object itself.
The path you use to get to it only matters during the resolution
of the path, after which it is, and must be, irrelevant. If there
is a path that leads to the object that is constructed some other
way, as the "fd" bit of /proc is, then the semantics of that path's
construction are what matter for the resolution of that path. Since
they have no way or reason to determine what the original
resolution path might have been there is no point in whinging
that the access of the /proc/8675309/fd/3 path is different from
the /a/foo path any more than there is that /b/bar might be
different.

>   
>> The path name is
>> an ethereal convenience and once traversed has no bearing on the
>> security state of the object.
>>     
>
> I think you've missed the point of Pavel's attack.  Pavel's attack allows
> a malicious process to take an existing read-only file descriptor and
> turn it into a read-write file descriptor, in cases where the filesystem
> permission bits should not have allowed the malicious process to do that.
> *That* is the security violation.  *That* should not be allowed.
>   

Again, once the file descriptor exists the only mode bits
(Or Smack label, or SELinux context, or ACL) that matters is
that of the object itself. It is perfectly OK to change a RO
to an RW if the mode bits allow it.

> Perhaps take a look at Pavel's post describing the attack again?

Yeah, I did that. It still looks like the complaint is that
/proc/8675309/fd/3 gives you the ability to gain RW access to
an object for which you have RW access.

Look, with hard links and the various mount options available
today you just can't count on setting the mode on a directory
to completely protect the files that it references. Look carefully
at the semantics of directories. They do not contain files. They
contain names of files. Setting the mode on a directory protects
access to the name of a file, not access to the file. There are
multiple ways to name a file, and access to any of the names of
a file to which you have access is sufficient to get you access
to the file.

As always, I could be missing something completely, but I have
been arguing Unix/Linux file system security issues for longer
than some of the people reading this have been alive.

Now, ask me if I think that /proc/8675309/fd/3 is a good idea,
and we'll have a different discussion, but from an old school
security standpoint (objects, subjects, accesses) there just is
not a problem.

If you want to introduce the notion that the pathname used to
access a file matters on subsequent access control decisions, well,
good luck, but don't say I didn't warn you.

