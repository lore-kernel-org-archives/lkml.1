Return-Path: <linux-kernel-owner+w=401wt.eu-S932621AbYBOBPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbYBOBPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759198AbYBOBPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:15:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:61654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbYBOBPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:15:34 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Is there a "blackhole" /dev/null directory?
To: =?ISO-8859-1?Q?Hans=2DJ=FCrgen?= Koch <hjk@linutronix.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Jasper Bryant-Greene <jasper@unix.geek.nz>,
       rzryyvzy <rzryyvzy@trashmail.net>, linux-kernel@vger.kernel.org,
       7eggert@gmx.de
Reply-To: 7eggert@gmx.de
Date: Fri, 15 Feb 2008 02:15:14 +0100
References: <9WIJE-1Nr-11@gated-at.bofh.it> <9WIJO-1Nr-19@gated-at.bofh.it> <9WITv-286-21@gated-at.bofh.it> <9WNTa-2x3-17@gated-at.bofh.it> <9WOch-2Wk-3@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1JPpAZ-0001Ej-9U@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+u7Sw8jIoRBYPKn76PO8CN96fTE6daZgKj19E
 NoEDq0pcowrMbtkMDITK7u9f6G5JR2EwzaskpYG0y1L6C/UPag
 ygu6Y+mF1VCSDO0Ok3zMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Jürgen Koch <hjk@linutronix.de> wrote:
> schrieb Jan Engelhardt <jengelh@computergmbh.de>:

>> There is a much more interesting 'problem' with a "/dev/null
>> directory".
>> 
>> Q: Why would you need such a directory?
>> A: To temporarily fool a program into believing it wrote something.
>> 
>> Q: Should all files disappear? (e.g. "unlink after open")
>> A: Maybe not, programs may stat() the file right afterwards and
>>    get confused by the "inexistence".
>> 
>> Q: What if a program attempts to mkdir /dev/nullmnt/foo to just
>>    create a file /dev/nullmnt/foo/barfile?
>> A: /dev/nullmnt/foo must continue to exist or be accepted for a while,
>>    or perhaps for eternity.
> 
> Well, the problem seems to be that a "directory" is not just data but
> also contains metadata. While it's easy to write data to /dev/null, you
> cannot simply discard metadata associated with a directory. So, such a
> "/dev/null-directory" would have to remember metadata (at least all
> created filenames including subdirectories) in the same way as other
> filesystems do. Only file _content_ can be discarded.
> To be honest, I still cannot see many sensible usecases for that...

Since both of you seem to know about the (possible) problems, maybe you can
take a look at my patch.

http://7eggert.dyndns.org:8080/tmp/autounlink.patch
(Not inline, because it would be duplicate in this thread.)
(Yes, this patch needs some cleanup. I just did checkpatch.)

First I thought I'd modify tmpfs to delete the file on O_CREAT, but it
turned out tmpfs will increase the dentry count in order to prevent the
delete-on-close effect. Skipping this step was allmost enough, I had to
prevent link() from pinning these files, too.

Some loops creating files or linking them did not show any decrease in
available memory, and to the best of my knowlege, I did not introduce new
memory leaks. And the best thing is: It's only 150 bytes of code. Not bad
for an additional mount flag, is it?

