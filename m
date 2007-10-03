Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbXJCK4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbXJCK4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbXJCK4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:56:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:62734 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbXJCK4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=HAxX8nrzVrLRvLw1ce0cDS7O3ZsxdWzseUOJHtWAz+kUu58fsyCrtRQ9HNf2UTD54lgT5SffsO19kSpBVD1nYZMDUxZIpyDeycyksHf2gPwZpSbhZZOTfvE+T8dB+httwDP56IcQPd12Wob5nzsROsWahal93Thj6rJacltoI/c=
Message-ID: <b647ffbd0710030355p116f9b36vae3f24e652921de6@mail.gmail.com>
Date: Wed, 3 Oct 2007 12:55:34 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Jarek Poplawski" <jarkao2@o2.pl>
Subject: Re: Network slowdown due to CFS
Cc: "Ingo Molnar" <mingo@elte.hu>, "David Schwartz" <davids@webmaster.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071003095057.GD1726@ff.dom.local>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_25130_23481127.1191408934328"
References: <20071002060607.GA18588@elte.hu>
	 <20071003080224.GB1726@ff.dom.local> <20071003081613.GA29904@elte.hu>
	 <20071003085636.GC1726@ff.dom.local> <20071003091058.GB7802@elte.hu>
	 <20071003095057.GD1726@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_25130_23481127.1191408934328
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 03/10/2007, Jarek Poplawski <jarkao2@o2.pl> wrote:
> I can't see anything about clearing. I think, this was about charging,
> which should change the key enough, to move a task to, maybe, a better
> place in a que (tree) than with current ways.

just a quick patch, not tested and I've not evaluated all possible
implications yet.
But someone might give it a try with his/(her -- are even more
welcomed :-) favourite sched_yield() load.

(and white space damaged)

--- sched_fair-old.c    2007-10-03 12:45:17.010306000 +0200
+++ sched_fair.c        2007-10-03 12:44:46.899851000 +0200
@@ -803,7 +803,35 @@ static void yield_task_fair(struct rq *r
                update_curr(cfs_rq);

                return;
+       } else if (sysctl_sched_compat_yield == 2) {
+               unsigned long ideal_runtime, delta_exec,
+                             delta_exec_weighted;
+
+               __update_rq_clock(rq);
+               /*
+                * Update run-time statistics of the 'current'.
+                */
+               update_curr(cfs_rq);
+
+               /*
+                * Emulate (speed up) the effect of us being preempted
+                * by scheduler_tick().
+                */
+               ideal_runtime = sched_slice(cfs_rq, curr);
+               delta_exec = curr->sum_exec_runtime -
curr->prev_sum_exec_runtime;
+
+               if (ideal_runtime > delta_exec) {
+                       delta_exec_weighted = ideal_runtime - delta_exec;
+
+                       if (unlikely(curr->load.weight != NICE_0_LOAD)) {
+                               delta_exec_weighted =
calc_delta_fair(delta_exec_weighted,
+
 &se->load);
+                       }
+                       se->vruntime += delta_exec_weighted;
+               }
+               return;
        }
+
        /*
         * Find the rightmost entry in the rbtree:
         */


>
> Jarek P.
>

-- 
Best regards,
Dmitry Adamushko

------=_Part_25130_23481127.1191408934328
Content-Type: text/x-patch; name="yield.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="yield.patch"; filename="yield.patch"; filename="yield.patch";
 filename="yield.patch"
X-Attachment-Id: f_f7bpyt4u

LS0tIHNjaGVkX2ZhaXItb2xkLmMJMjAwNy0xMC0wMyAxMjo0NToxNy4wMTAzMDYwMDAgKzAyMDAK
KysrIHNjaGVkX2ZhaXIuYwkyMDA3LTEwLTAzIDEyOjQ0OjQ2Ljg5OTg1MTAwMCArMDIwMApAQCAt
ODAzLDcgKzgwMywzNSBAQCBzdGF0aWMgdm9pZCB5aWVsZF90YXNrX2ZhaXIoc3RydWN0IHJxICpy
CiAJCXVwZGF0ZV9jdXJyKGNmc19ycSk7CiAKIAkJcmV0dXJuOworCX0gZWxzZSBpZiAoc3lzY3Rs
X3NjaGVkX2NvbXBhdF95aWVsZCA9PSAyKSB7CisJCXVuc2lnbmVkIGxvbmcgaWRlYWxfcnVudGlt
ZSwgZGVsdGFfZXhlYywKKwkJCSAgICAgIGRlbHRhX2V4ZWNfd2VpZ2h0ZWQ7CisKKwkJX191cGRh
dGVfcnFfY2xvY2socnEpOworCQkvKgorCQkgKiBVcGRhdGUgcnVuLXRpbWUgc3RhdGlzdGljcyBv
ZiB0aGUgJ2N1cnJlbnQnLgorCQkgKi8KKwkJdXBkYXRlX2N1cnIoY2ZzX3JxKTsKKworCQkvKgor
CQkgKiBFbXVsYXRlIHRoZSBlZmZlY3Qgb2YgdXMgYmVpbmcgcHJlZW1wdGVkCisJCSAqIGJ5IHNj
aGVkdWxlcl90aWNrKCkuCisJCSAqLworCQlpZGVhbF9ydW50aW1lID0gc2NoZWRfc2xpY2UoY2Zz
X3JxLCBjdXJyKTsKKwkJZGVsdGFfZXhlYyA9IGN1cnItPnN1bV9leGVjX3J1bnRpbWUgLSBjdXJy
LT5wcmV2X3N1bV9leGVjX3J1bnRpbWU7CisKKwkJaWYgKGlkZWFsX3J1bnRpbWUgPiBkZWx0YV9l
eGVjKSB7CisJCQlkZWx0YV9leGVjX3dlaWdodGVkID0gaWRlYWxfcnVudGltZSAtIGRlbHRhX2V4
ZWM7CisKKwkJCWlmICh1bmxpa2VseShjdXJyLT5sb2FkLndlaWdodCAhPSBOSUNFXzBfTE9BRCkp
IHsKKwkJCQlkZWx0YV9leGVjX3dlaWdodGVkID0gY2FsY19kZWx0YV9mYWlyKGRlbHRhX2V4ZWNf
d2VpZ2h0ZWQsCisJCQkJCQkJCQkmc2UtPmxvYWQpOworCQkJfQorCQkJc2UtPnZydW50aW1lICs9
IGRlbHRhX2V4ZWNfd2VpZ2h0ZWQ7CisJCX0KKwkJcmV0dXJuOwogCX0KKwogCS8qCiAJICogRmlu
ZCB0aGUgcmlnaHRtb3N0IGVudHJ5IGluIHRoZSByYnRyZWU6CiAJICovCg==
------=_Part_25130_23481127.1191408934328--
