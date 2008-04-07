Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYDGSip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYDGSip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYDGSig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:38:36 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:35164 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949AbYDGSif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:38:35 -0400
Subject: Re: [PATCH] Fix paranoia about using BIOS quickboot mechanism.
From: Alok Kataria <akataria@vmware.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Daniel Arai <arai@vmware.com>,
       Zachary Amsden <zach@vmware.com>
In-Reply-To: <20080407082256.GA3524@elte.hu>
References: <1207352954.6294.30.camel@promb-2n-dhcp158.eng.vmware.com>
	 <20080407082256.GA3524@elte.hu>
Content-Type: multipart/mixed; boundary="=-BPR2jdaO5DxFwK2JUi/0"
Organization: VMware, Inc.
Date: Mon, 07 Apr 2008 11:38:33 -0700
Message-Id: <1207593513.5864.25.camel@promb-2n-dhcp158.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BPR2jdaO5DxFwK2JUi/0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2008-04-07 at 10:22 +0200, Ingo Molnar wrote:
> * Alok Kataria <akataria@vmware.com> wrote:
> 
> > Make sure that we clear the "shutdown status flag" in the CMOS 
> > register after each CPU is brought up.  This fixes a problem where the 
> > "shutdown status flag" may remain set when a CPU is brought up after 
> > booting.
> 
> btw., what problem does this result in, exactly?

The shutdown status flag set to "0xA", corresponds to "JMP double word
request without INT init".

This JMP at reboot time is at an unintended location. And results in
Triple faults in our case.
Though this error at reboot can be safely ignored in a VM environment,
am not sure what the effect would be on a physical system. May be it
will result in a triple fault and an eventual hardware reset thus
masking this BUG in the kernel.

This fix just makes sure that we reset that status flag after
initialization is done.

> 
> > Tested on the X86 tree.
> 
> > + * Cleanup possible dangling ends...
> > + */
> > + smpboot_restore_warm_reset_vector();
> > +
> > return boot_error;
> > }
> 
> patch got whitespace damaged - have a look at 
> Documentation/email-clients.txt for details about how to send patches as 
> in-line text. (or send the patch as an attachment - we accept x86 
> patches as attachments too)

Ah...I think i followed the instructions there, will have to look what
went wrong, anyways, will go for the easier solution, here is the patch
attached.  

Thanks & Regards,
Alok

> 
> 	Ingo

--=-BPR2jdaO5DxFwK2JUi/0
Content-Disposition: attachment; filename=fix-reboot-after-cpu-hotplug.patch
Content-Type: text/x-patch; name=fix-reboot-after-cpu-hotplug.patch; charset=utf-8
Content-Transfer-Encoding: base64

Rml4IHBhcmFub2lhIGFib3V0IHVzaW5nIEJJT1MgcXVpY2tib290IG1lY2hhbmlzbS4NCg0KTWFr
ZSBzdXJlIHRoYXQgd2UgY2xlYXIgdGhlICJzaHV0ZG93biBzdGF0dXMgZmxhZyIgaW4gdGhlIENN
T1MgcmVnaXN0ZXINCmFmdGVyIGVhY2ggQ1BVIGlzIGJyb3VnaHQgdXAuICBUaGlzIGZpeGVzIGEg
cHJvYmxlbSB3aGVyZSB0aGUgInNodXRkb3duDQpzdGF0dXMgZmxhZyIgbWF5IHJlbWFpbiBzZXQg
d2hlbiBhIENQVSBpcyBicm91Z2h0IHVwIGFmdGVyIGJvb3RpbmcuDQoNClNpZ25lZC1vZmYtYnk6
IEFsb2sgTiBLYXRhcmlhIDxha2F0YXJpYUB2bXdhcmUuY29tPg0KU2lnbmVkLW9mZi1ieTogRGFu
IEFyYWkgPGFyYWlAdm13YXJlLmNvbT4NCg0KLS0tDQogYXJjaC94ODYva2VybmVsL3NtcGJvb3Qu
YyB8ICAgMTAgKysrKystLS0tLQ0KIDEgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA1
IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL3NtcGJvb3QuYyBi
L2FyY2gveDg2L2tlcm5lbC9zbXBib290LmMNCmluZGV4IDUzMjFlMzUuLjBiOGJiYTggMTAwNjQ0
DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvc21wYm9vdC5jDQorKysgYi9hcmNoL3g4Ni9rZXJuZWwv
c21wYm9vdC5jDQpAQCAtMTAxMCw2ICsxMDEwLDExIEBAIGRvX3Jlc3Q6DQogCS8qIG1hcmsgInN0
dWNrIiBhcmVhIGFzIG5vdCBzdHVjayAqLw0KIAkqKCh2b2xhdGlsZSB1bnNpZ25lZCBsb25nICop
dHJhbXBvbGluZV9iYXNlKSA9IDA7DQogDQorCS8qDQorCSAqIENsZWFudXAgcG9zc2libGUgZGFu
Z2xpbmcgZW5kcy4uLg0KKwkgKi8NCisJc21wYm9vdF9yZXN0b3JlX3dhcm1fcmVzZXRfdmVjdG9y
KCk7DQorDQogCXJldHVybiBib290X2Vycm9yOw0KIH0NCiANCkBAIC0xMjYzLDExICsxMjY4LDYg
QEAgdm9pZCBfX2luaXQgbmF0aXZlX3NtcF9wcmVwYXJlX2Jvb3RfY3B1KHZvaWQpDQogDQogdm9p
ZCBfX2luaXQgbmF0aXZlX3NtcF9jcHVzX2RvbmUodW5zaWduZWQgaW50IG1heF9jcHVzKQ0KIHsN
Ci0JLyoNCi0JICogQ2xlYW51cCBwb3NzaWJsZSBkYW5nbGluZyBlbmRzLi4uDQotCSAqLw0KLQlz
bXBib290X3Jlc3RvcmVfd2FybV9yZXNldF92ZWN0b3IoKTsNCi0NCiAJRHByaW50aygiQm9vdCBk
b25lLlxuIik7DQogDQogCWltcHJlc3NfZnJpZW5kcygpOw0KLS0gDQoxLjUuNA0KDQo=


--=-BPR2jdaO5DxFwK2JUi/0--
