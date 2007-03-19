Return-Path: <linux-kernel-owner+w=401wt.eu-S933776AbXCSC6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbXCSC6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 22:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933780AbXCSC6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 22:58:32 -0400
Received: from relay4.usu.ru ([194.226.235.39]:34993 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933776AbXCSC6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 22:58:31 -0400
Message-ID: <45FDFC69.6020605@ums.usu.ru>
Date: Mon, 19 Mar 2007 07:58:49 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>
In-Reply-To: <87hcsius7b.fsf@duaron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> "Alexander E. Patrakov" <patrakov@ums.usu.ru> writes:
> 
>>  * Removes CONFIG_FAT_DEFAULT_IOCHARSET, now CONFIG_NLS_DEFAULT is used 
>> for this purpose. This is because the correct setting of both must match 
>> the user's locale
> 
> The some filesystems want to use utf-8, and others don't want to use
> utf-8, no?  And is it also true about some devices using vfat?

Sorry, I can't parse this. Linux programs see filenames in the charset 
specified by the "iocharset" mount option or this default. If some filenames 
are in UTF-8 and some aren't, the "ls" command cannot show them all 
correctly on a properly configured (aka: correctly displays the output of 
"yes --help") terminal (because it assumes that all filenames are in the 
same charset as indicated by the output of "locale charmap"). IMHO, this is 
insane enough, and it makes sense  to disable this by default.

>>  * Merges the two CONFIG_SMB_NLS_REMOTE and CONFIG_FAT_DEFAULT_CODEPAGE 
>> options into one, named CONFIG_CODEPAGE_DEFAULT. This is because the 
>> correct setting of both must match the code page used by MS-DOS in the 
>> user's country. For the same reason, CONFIG_SMB_NLS_DEFAULT is removed 
>> (the only sane choice is "y")
> 
> No. Unfortunately the real is not simple like it in some case.

More details please. Are you saying that for Japanese people the codepage 
for FAT and SMB filesystems is not the same? How do Microsoft products work 
then? What do they send over the wire?

>>  * Makes the FAT filesystem accept both the old-style "codepage=866" 
>> mount option (which is inconsistent with other filesystems requiring a 
>> codepage option) and the new-style "codepage=cp866" option. This is 
>> necessary because CONFIG_CODEPAGE_DEFAULT must work for all filesystems 
>> that use it
> 
> You allow to set any nls to codepage? If so, it is not good.

I did this because it involved less changes. Only FAT treats codepage as a 
number. All other filesystems already allow arbitrary NLS as a codepage 
mount parameter.

>>  * Downgrades the UTF-8 FAT warning to a note, because, while using the 
>> utf8 iocharset produces a case-sensitive FAT filesystem, other 
>> iocharsets simply produce wrong characters, which is much worse
> 
> No, utf-8 makes completely wrong entry. It's more wrong than other nls.

For any non-UTF-8 based locales, the other NLS is correct and utf8 indeed 
would produce completely wrong characters. But for UTF-8 based locales, utf8 
is the only correct iocharset.

And the downgraded warning is not for those who mis-use the utf8 iocharset 
in non-UTF-8 locales, they need a completely different wording: "your 
iocharset doesn't match the locale settings, non-ASCII characters will be 
completely wrong in filenames". Unfortunately, this condition is impossible 
to detect from within the kernel.

>>  * Makes CONFIG_NLS_DEFAULT and CONFIG_CODEPAGE_DEFAULT adjustable at 
>> runtime via the following mechanisms:
> 
> The configurable sounds sane, and it may help some case. But, it should
> not be system global. At least, I think the default would be per-filesystem,
> otherwise some configs seems to be needed for other filesystem after all.

OK, now I see that your primary objection is to merging options, and 
disagree (incorrect locale setup on your side is suspected). For meaningful 
discussion, I want to see the following:

1) Output of "locale -a"
2) Output of "yes --help" from the same terminal
3) The correct iocharset and codepage for mounting FAT filesystems on USB 
flash drives that are known readable under Windows (here "correct" = "ls in 
this terminal shows filenames correctly").
4) The same for SMB filesystems.

-- 
Alexander E. Patrakov
