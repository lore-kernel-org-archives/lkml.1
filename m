Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbZDOOwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbZDOOwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZDOOvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:51:51 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:42354 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZDOOvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:51:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AA+MehQFoRZn3qXiNWLz2Z4QkfLbSXRfdk4W9bUQlFuYjSdU2PHdBbQYH+5XHvWbuZ
         TF1RSugG2SEWXc5sGuEECDrSZGnXR3trqLpIgJlBQF9/r2J/q1ZzuDYxEkxJRIwETXUq
         E2z1EzD8wklMt5XLAdzl1MVlfihqLC5u5R6r0=
MIME-Version: 1.0
In-Reply-To: <49E5EABB.9010402@garzik.org>
References: <49E38331.3090808@garzik.org> <49E38393.8000700@garzik.org>
	 <20090413182746.GA9954@elte.hu> <49E5EABB.9010402@garzik.org>
Date: Wed, 15 Apr 2009 16:51:48 +0200
Message-ID: <b647ffbd0904150751u64e69097q79c511533f949c00@mail.gmail.com>
Subject: Re: microcode driver newly spews warnings
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Oruba <peter.oruba@amd.com>,
       amd64-microcode@amd64.org, Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: multipart/mixed; boundary=0015174c10a0509767046799160d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c10a0509767046799160d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

2009/4/15 Jeff Garzik <jeff@garzik.org>:
> Ingo Molnar wrote:
>>
>> (added Cc:s)
>>
>> * Jeff Garzik <jeff@garzik.org> wrote:
>>
>>> Jeff Garzik wrote:
>>>>
>>>> Kernel: 2.6.30-rc1-00306-g8371f87
>>>> Hardware: ICH10 x86-64
>>>>
>>>> This is a regression from 2.6.29.  Microcode spews the following WARNING
>>>> multiple times during boot:
>>>>
>>>>> ------------[ cut here ]------------
>>>>> WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
>>>>> Hardware name:         sysfs group ffffffffa0209700 not found for
>>>>>  kobject 'cpu0'
>
>
> Update:  Regression occurs in 2.6.30-rc2.
>
> I've now reproduced this on ICH9/Core2 as well as ICH10/Nahelem.

Hi,


the following patch should eliminate the problem (and revert to the
old behavior that was altered by Rusty's patch).

btw., is the upgrade done with the help of some microcode startup
script? I wonder why it decides to unload the microcode module (what
kind of checks it does to take this decision)...

(non-whitespace-damaged version is enclosed. I appologize for the
inconvenience, don't have a proper e-mail client at hand)


---

Keep sysfs files around for cpus even when we failed to locate
microcode for them at the moment of module loading. The appropriate
microcode firmware can become available later on.


--- arch/x86/kernel/microcode_core-orig.c       2009-04-15
10:34:25.000000000 +0200
+++ arch/x86/kernel/microcode_core.c            2009-04-15
16:27:51.000000000 +0200
@@ -380,8 +380,6 @@ static int mc_sysdev_add(struct sys_devi
                return err;

        err = microcode_init_cpu(cpu);
-       if (err)
-               sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);

        return err;
 }


>
>        Jeff
>

-- 
Best regards,
Dmitry Adamushko

--0015174c10a0509767046799160d
Content-Type: text/x-patch; charset=US-ASCII; name="microcode-fix-warning.patch"
Content-Disposition: attachment; filename="microcode-fix-warning.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftk4f02m0

LS0tIGFyY2gveDg2L2tlcm5lbC9taWNyb2NvZGVfY29yZS1vcmlnLmMJMjAwOS0wNC0xNSAxMDoz
NDoyNS4wMDAwMDAwMDAgKzAyMDAKKysrIGFyY2gveDg2L2tlcm5lbC9taWNyb2NvZGVfY29yZS5j
CQkyMDA5LTA0LTE1IDE2OjI3OjUxLjAwMDAwMDAwMCArMDIwMApAQCAtMzgwLDggKzM4MCw2IEBA
IHN0YXRpYyBpbnQgbWNfc3lzZGV2X2FkZChzdHJ1Y3Qgc3lzX2RldmkKIAkJcmV0dXJuIGVycjsK
IAogCWVyciA9IG1pY3JvY29kZV9pbml0X2NwdShjcHUpOwotCWlmIChlcnIpCi0JCXN5c2ZzX3Jl
bW92ZV9ncm91cCgmc3lzX2Rldi0+a29iaiwgJm1jX2F0dHJfZ3JvdXApOwogCiAJcmV0dXJuIGVy
cjsKIH0K
--0015174c10a0509767046799160d--
