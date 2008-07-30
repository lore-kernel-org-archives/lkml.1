Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbYG3KeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbYG3KeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYG3KeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:34:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:31123 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYG3KeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=njGghXBq92CFm7KjfHbBmP96wDWfnw4ftWEXQTOlpINKTCWdNtmC69q3DfqGF54LTf
         i/MsjEDheoj4WguZ5oUfVQWSyf7ZCMLKUnNiad/TH5gkwrk5fooaVj1cofh8sTPyy8mv
         gMtsrm70jxzpxw+EKgjk3O0fBhe6kUbv9XyBM=
Message-ID: <b647ffbd0807300334q57cdca6fu474cc7b6bed36102@mail.gmail.com>
Date: Wed, 30 Jul 2008 12:34:04 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Oruba" <peter.oruba@amd.com>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
Cc: "Max Krasnyansky" <maxk@qualcomm.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0807300257x43dd6018o59533bec11b7a504@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_63318_27973093.1217414044538"
References: <20080729154103.007575982@amd.com>
	 <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>
	 <488F581B.7060009@qualcomm.com> <48903431.9060707@amd.com>
	 <b647ffbd0807300257x43dd6018o59533bec11b7a504@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_63318_27973093.1217414044538
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/7/30 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> 2008/7/30 Peter Oruba <peter.oruba@amd.com>:
>>> [ ... ]
>>
>> Since ucode updates may fix severe issues, it is supposed to happen as early
>> as possible. If you re-plug your CPU into your socket, your BIOS also
>> applies a ucode patch, but that won't necessarily be the latest and critical
>> one.
>
> Hum, let's say we don't do it from cpu-hotplug handlers [1] but from
> start_secondary() before calling cpu_idle()? [*]
>
> This way, we do it before any other task may have a chance to run on a
> cpu which is not a case with cpu-hotplug handlers
> (and we don't mess-up with cpu-hotplug events :-)
>
> [ the drawback is that 'microcode' subsystem is not local to
> microcode.c anymore ]
>
> [1] if we need a sync. operation in cpu-hotplug handlers and IPI is
> not ok (say, we need to run in a sleepablel context) then perhaps it's
> workqueues + wait_on_cpu_work(). But then it's not a bit later than
> could have been with [*].
>
> heh, this issue has already popped up in another thread so it should
> be fixed asap, imho.
>
> Ingo, Peter? What would be the best way from your pov?

or let's just use smth like a patch below so far:

(non-white-space-damaged version is enclosed)

--- kernel/cpu.c-old    2008-07-30 12:31:15.000000000 +0200
+++ kernel/cpu.c        2008-07-30 12:32:02.000000000 +0200
@@ -349,6 +349,8 @@ static int __cpuinit _cpu_up(unsigned in
                goto out_notify;
        BUG_ON(!cpu_online(cpu));

+       cpu_set(cpu, cpu_active_map);
+
        /* Now call notifier in preparation. */
        raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);

@@ -383,9 +385,6 @@ int __cpuinit cpu_up(unsigned int cpu)

        err = _cpu_up(cpu, 0);

-       if (cpu_online(cpu))
-               cpu_set(cpu, cpu_active_map);
-
 out:
        cpu_maps_update_done();
        return err;


>
>
>>
>> Peter
>>
>
> --
> Best regards,
> Dmitry Adamushko
>



-- 
Best regards,
Dmitry Adamushko

------=_Part_63318_27973093.1217414044538
Content-Type: text/x-patch; name=move-cpu_set-cpu_active_map.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fj9svc9c0
Content-Disposition: attachment; filename=move-cpu_set-cpu_active_map.patch

LS0tIGtlcm5lbC9jcHUuYy1vbGQJMjAwOC0wNy0zMCAxMjozMToxNS4wMDAwMDAwMDAgKzAyMDAK
KysrIGtlcm5lbC9jcHUuYwkyMDA4LTA3LTMwIDEyOjMyOjAyLjAwMDAwMDAwMCArMDIwMApAQCAt
MzQ5LDYgKzM0OSw4IEBAIHN0YXRpYyBpbnQgX19jcHVpbml0IF9jcHVfdXAodW5zaWduZWQgaW4K
IAkJZ290byBvdXRfbm90aWZ5OwogCUJVR19PTighY3B1X29ubGluZShjcHUpKTsKIAorCWNwdV9z
ZXQoY3B1LCBjcHVfYWN0aXZlX21hcCk7CisKIAkvKiBOb3cgY2FsbCBub3RpZmllciBpbiBwcmVw
YXJhdGlvbi4gKi8KIAlyYXdfbm90aWZpZXJfY2FsbF9jaGFpbigmY3B1X2NoYWluLCBDUFVfT05M
SU5FIHwgbW9kLCBoY3B1KTsKIApAQCAtMzgzLDkgKzM4NSw2IEBAIGludCBfX2NwdWluaXQgY3B1
X3VwKHVuc2lnbmVkIGludCBjcHUpCiAKIAllcnIgPSBfY3B1X3VwKGNwdSwgMCk7CiAKLQlpZiAo
Y3B1X29ubGluZShjcHUpKQotCQljcHVfc2V0KGNwdSwgY3B1X2FjdGl2ZV9tYXApOwotCiBvdXQ6
CiAJY3B1X21hcHNfdXBkYXRlX2RvbmUoKTsKIAlyZXR1cm4gZXJyOwo=
------=_Part_63318_27973093.1217414044538--
