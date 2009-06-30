Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZF3HBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZF3HBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 03:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZF3HBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 03:01:06 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:39451 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbZF3HBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 03:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bHNgDlU3E9CWCbxNCNaayG/4A0a7cOfMhPNZXj0S77VhCuUod1l0jMsvoqkco5WKXt
         3lYPtylJswhar5OcTKecu7Kf0APs56JK7PEFZdWS+AAFfDstZJxuOLfIJVTXd9QCuspL
         nt0oC+pEsWhAMv9YkAvyOHksZ0+ca0qY8KPxQ=
MIME-Version: 1.0
In-Reply-To: <1246307644.4534.26298.camel@localhost.localdomain>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
	 <1246307644.4534.26298.camel@localhost.localdomain>
Date: Tue, 30 Jun 2009 15:01:07 +0800
Message-ID: <3877989d0906300001u2f185fb0lcab5614e245efc21@mail.gmail.com>
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
From: Luming Yu <luming.yu@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: multipart/mixed; boundary=0015174bee88f2b63d046d8b5eb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174bee88f2b63d046d8b5eb1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks for review. How about the following patch?

/**The patch is enclosed in text attachment**
**Using web client to send the patch**
**below is for review, please apply attached  patch*/


Signed-off-by: Yu Luming <luming.yu@intel.com>

 apic.c         |    5 ++++-
 apic_flat_64.c |    7 ++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)


--- linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c.0	2009-06-29
23:45:05.000000000 -0600
+++ linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c	2009-06-30
00:37:56.000000000 -0600
@@ -419,7 +419,10 @@
 static void lapic_timer_broadcast(const struct cpumask *mask)
 {
 #ifdef CONFIG_SMP
-	apic->send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
+	if (unlikely(cpumask_weight(mask) == num_online_cpus() -1))
+		apic->send_IPI_all(LOCAL_TIMER_VECTOR);
+	else
+		apic->send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
 #endif
 }

--- linux-2.6.30-rc6/arch/x86/kernel/apic/apic_flat_64.c.0	2009-06-29
00:13:26.000000000 -0600
+++ linux-2.6.30-rc6/arch/x86/kernel/apic/apic_flat_64.c	2009-06-29
00:11:23.000000000 -0600
@@ -274,7 +274,12 @@

 static void physflat_send_IPI_all(int vector)
 {
-	physflat_send_IPI_mask(cpu_online_mask, vector);
+	if (vector == NMI_VECTOR) {
+		physflat_send_IPI_mask(cpu_online_mask, vector);
+	} else {
+		__default_send_IPI_shortcut(APIC_DEST_ALLINC,
+					    vector, apic->dest_logical);
+	}
 }

 static unsigned int physflat_cpu_mask_to_apicid(const struct cpumask *cpumask)

--0015174bee88f2b63d046d8b5eb1
Content-Type: application/octet-stream; name="1.patch"
Content-Disposition: attachment; filename="1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwk9vuvy0

LS0tIGxpbnV4LTIuNi4zMC1yYzYvYXJjaC94ODYva2VybmVsL2FwaWMvYXBpYy5jLjAJMjAwOS0w
Ni0yOSAyMzo0NTowNS4wMDAwMDAwMDAgLTA2MDAKKysrIGxpbnV4LTIuNi4zMC1yYzYvYXJjaC94
ODYva2VybmVsL2FwaWMvYXBpYy5jCTIwMDktMDYtMzAgMDA6Mzc6NTYuMDAwMDAwMDAwIC0wNjAw
CkBAIC00MTksNyArNDE5LDEwIEBACiBzdGF0aWMgdm9pZCBsYXBpY190aW1lcl9icm9hZGNhc3Qo
Y29uc3Qgc3RydWN0IGNwdW1hc2sgKm1hc2spCiB7CiAjaWZkZWYgQ09ORklHX1NNUAotCWFwaWMt
PnNlbmRfSVBJX21hc2sobWFzaywgTE9DQUxfVElNRVJfVkVDVE9SKTsKKwlpZiAodW5saWtlbHko
Y3B1bWFza193ZWlnaHQobWFzaykgPT0gbnVtX29ubGluZV9jcHVzKCkgLTEpKQorCQlhcGljLT5z
ZW5kX0lQSV9hbGwoTE9DQUxfVElNRVJfVkVDVE9SKTsKKwllbHNlCisJCWFwaWMtPnNlbmRfSVBJ
X21hc2sobWFzaywgTE9DQUxfVElNRVJfVkVDVE9SKTsKICNlbmRpZgogfQogCi0tLSBsaW51eC0y
LjYuMzAtcmM2L2FyY2gveDg2L2tlcm5lbC9hcGljL2FwaWNfZmxhdF82NC5jLjAJMjAwOS0wNi0y
OSAwMDoxMzoyNi4wMDAwMDAwMDAgLTA2MDAKKysrIGxpbnV4LTIuNi4zMC1yYzYvYXJjaC94ODYv
a2VybmVsL2FwaWMvYXBpY19mbGF0XzY0LmMJMjAwOS0wNi0yOSAwMDoxMToyMy4wMDAwMDAwMDAg
LTA2MDAKQEAgLTI3NCw3ICsyNzQsMTIgQEAKIAogc3RhdGljIHZvaWQgcGh5c2ZsYXRfc2VuZF9J
UElfYWxsKGludCB2ZWN0b3IpCiB7Ci0JcGh5c2ZsYXRfc2VuZF9JUElfbWFzayhjcHVfb25saW5l
X21hc2ssIHZlY3Rvcik7CisJaWYgKHZlY3RvciA9PSBOTUlfVkVDVE9SKSB7CisJCXBoeXNmbGF0
X3NlbmRfSVBJX21hc2soY3B1X29ubGluZV9tYXNrLCB2ZWN0b3IpOworCX0gZWxzZSB7CisJCV9f
ZGVmYXVsdF9zZW5kX0lQSV9zaG9ydGN1dChBUElDX0RFU1RfQUxMSU5DLAorCQkJCQkgICAgdmVj
dG9yLCBhcGljLT5kZXN0X2xvZ2ljYWwpOworCX0KIH0KIAogc3RhdGljIHVuc2lnbmVkIGludCBw
aHlzZmxhdF9jcHVfbWFza190b19hcGljaWQoY29uc3Qgc3RydWN0IGNwdW1hc2sgKmNwdW1hc2sp
Cg==
--0015174bee88f2b63d046d8b5eb1--
