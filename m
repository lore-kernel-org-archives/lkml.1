Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbXE0FdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbXE0FdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 01:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXE0FdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 01:33:03 -0400
Received: from smtpout.mac.com ([17.250.248.177]:61819 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbXE0Fc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 01:32:59 -0400
In-Reply-To: <12000.1180233422@turing-police.cc.vt.edu>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com> <Line.LNX.4.64.0705261442000.23020@d.namei> <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com> <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com> <12000.1180233422@turing-police.cc.vt.edu>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <D9C70A8C-2307-4E5F-AE5F-2A347284B879@mac.com>
Cc: Toshiharu Harada <haradats@gmail.com>, James Morris <jmorris@namei.org>,
       casey@schaufler-ca.com, Andreas Gruenbacher <agruen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Sun, 27 May 2007 01:32:33 -0400
To: Valdis.Kletnieks@vt.edu
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 26, 2007, at 22:37:02, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 26 May 2007 22:10:34 EDT, Kyle Moffett said:
>> On May 26, 2007, at 19:08:56, Toshiharu Harada wrote:
>
>>> (1) Object labeling has a assumption that labels are always
>>> properly defined and maintained. This can not be easily achieved.
>>
>> That's a circular argument, and a fairly trivial one at that.  If you
>> can't properly manage your labels, then how do you expect any
>> security at all?
>
> Unfortunately, it's not at all as simple as all that. Toshiharu is  
> quite correct that it isn't always easy to actually implement.   
> Consider how many ad-croc usages of 'restorecon' are needed to get  
> a Fedora SELinux box through rc.sysinit:

While I don't think restorecon is really necessary to properly boot  
SELinux-enabled (I've got a Debian box with some heavily customized  
policy which does so just fine), I am of the opinion that adding a  
"name" parameter to the file/directory create actions would be  
useful.  For example, with such support you could actually specify a  
type-transition rule conditional on a specific name or substring:

named_type_transition sshd_t tmp_t:sock_file prefix "ssh-" ssh_sock_t;

Useful options for matching would be "prefix", "suffix", "substr 
(start,len)".  "regex" would be nice but is sorta computationally  
intensive and would be likely to cause more problems than it solves.

> /sbin/restorecon  -R /dev 2>/dev/null
> [ -n "$SELINUX_STATE" ] && restorecon /dev/mapper /dev/mapper/ 
> control >/dev/null 2>&1

These can go away if you modify your policy and  pass "-o  
fscontext=system_u:object_r:dev_t" to the mount command for the /dev  
tmpfs, changing both the filesystem and the default directory labels  
from the default "system_u:object_r:tmpfs_t".  This will work as long  
as your policy files contain appropriate transitions from the dev_t  
type.

> REBOOTFLAG=`restorecon -v /sbin/init`
> restorecon /etc/mtab /etc/ld.so.cache /etc/blkid/blkid.tab /etc/ 
> resolv.conf >/dev/null 2>&1
> [ -n "$SELINUX_STATE" ] && restorecon /tmp
> [ -n "$SELINUX_STATE" ] && restorecon /tmp/.ICE-unix >/dev/null 2>&1

I believe these are to handle rebooting from non-SELinux mode.  There  
are two solutions to this kind of problem:
(1) Failing the boot if the labels are wrong
(2) Fixing the labels (and rebooting if necessary)
It would appear that FC does the latter, although for certain high- 
security systems (such as firewalls handling classified/confidential  
data), the first option is the only acceptable one.

> [ -n "$SELINUX_STATE" ] && restorecon /dev/pts >/dev/null 2>&1

I think this can be handled with some combination of appropriate  
SELinux policy and mount options.  At least, I don't need this in the  
boot scripts on my heavily customized Debian SELinux box.

> [ -n "$SELINUX_STATE" -a -e "$path" ] && restorecon -R "$path"

I don't know what the point of this generic line is; but I certainly  
don't have anything of the sort on my test system, and it appears to  
work just fine.

> And that's just getting the system up to single-user.  Things like  
> sendmail and sshd require more restorecon handholding in their  
> rc.init files.
>
> Or just look at the creeping horror that is 'restorecond' (in  
> particular, consider that the default restorcond.conf contains the  
> strings '~/public_html' and '~/.mozilla/plugins/ 
> libflashplayer.so'.  Yee. Frikkin. Hah. ;)

Part of the reason that Fedora has a large quantity of that  
restorecon and restorecond crap is that there  is a certain amount of  
broken binary software needing executable stack/heap (such as  
flashplayer), programs without comprehensive or complete policies, or  
programs which by definition need extra support for SELinux.

For example, to really complete the SELinux model you need editors  
and tools which understand security labels the same way they  
understand UNIX permissions.  With a bit of vim scripting I can  
probably make it run external commands to read file labels before it  
reads the file itself and modify /proc/self/attr/fscreate before  
writing out the file, similar to the way it would keep track of the  
standard DAC permissions on files it modifies.

There's also the fact that corporate products have fixed release  
schedules so remaining bugs in each release tend to get papered over  
instead of fixed properly (such as the restorecon in FC init- 
scripts).  I haven't seen many problems with the SELinux model which  
aren't associated with working around buggy software or missing  
features.

Cheers,
Kyle Moffett
