Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbZFYP1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbZFYP1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZFYP1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:27:38 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:53168 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZFYP1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:27:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nTVLAAcDXsQuDALTs3XQXD92AwvcM5uphmDwrtmGlktyCZtbS/poCKHF9726GoP9uG
         NSlRzSZZHc/5cnglU4VmeHelj7WAJxJfepoFQETRBLhAAi7hZXz/M0LP6WPHIP1jz5gf
         z+pfARW0ajfaIx1Cri4m+cShuzyd2WUyUzbDA=
Message-ID: <4A4396E9.1030509@gmail.com>
Date: Thu, 25 Jun 2009 17:25:29 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<clqON-2Xv-5@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk> <4A1B164B.1010108@gmail.com> <4A1B76EB.9040500@kernel.org> <4A1B8193.1010703@gmail.com> <4A1B8328.80801@kernel.org> <4A1B8873.1040101@gmail.com> <4A1BEFB6.80205@kernel.org> <4A1C316C.9040201@gmail.com> <4A1C8444.9040605@kernel.org> <4A1D47C6.1070504@gmail.com> <4A2424A2.5020704@gmail.com> <4A25EA78.7070705@kernel.org> <4A25FBD1.70000@gmail.com> <4A2A1521.5020407@gmai l.com> <4A437442.8000909@gmail.com>
In-Reply-To: <4A437442.8000909@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2009 02:57 PM, Tejun Heo wrote:
> Sorry about the long delay.
>
> The result is perfectly good and yeah dump_stack() on the issue path
> would help but the problem is that block IO requests are processed
> asynchronously so by the time we find out which request fail, the
> requester stack is long gone.  We can either record the stack trace
> with each request or trace it back one step at a time by chasing down
> the completion callbacks.  The first requires more coding, so... :-)
>
> Looks like the request gotta be coming from __breadahead().  The only
> place this is used in ext4 is in __ext4_get_inode_loc().  Ah.. it also
> contains the matching error message.  I still don't see how the READA
> buffer reads can affect the synchronous path.  They're doing proper
> exclusion via buffer lock.  Maybe they're getting merged?  Yeap, looks
> like block code is merging READAs and regular READs.
>
> Can you please try the attached patch and reproduce the problem and
> report the kernel log?  Hopefully, this will be the last debug run.
>    

Hi Tejun,

I've recently switched my root partition from OpenSUSE 11.1 to Fedora 11 
and since then I've not again seen the issue. I'm still using vanilla 
2.6.30 generated with the same .config and EXT4 as before, so I have no 
idea why I cannot reproduce the issue. I still use hibernate + sleep 
frequently, and I just checked - I have 5 days uptime with a mount count 
of 20 and the file-system is still clean.

The one big difference is that my original partition was a EXT2 -> EXT3 
-> EXT4 upgrade job over a long period of time, and some of the EXT4 
parameters now used by Fedora 11 on the reformatted root partition are 
different from what I had then. Here is a summary of the differences in 
case it matters at all:

Current settings:
Default mount options:    user_xattr acl
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Required extra isize:     28
Desired extra isize:      28
Default directory hash:   half_md4

Previous settings:
Default mount options:    (none)
Inodes per group:         8176
Inode blocks per group:   511
Default directory hash:   tea

If I do notice any such errors again I'll apply the debug patch and let 
you know, but it does seem as if the upgrade made this issue disappear...

Regards,
Niel
