Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbYHaVDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbYHaVDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 17:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbYHaVD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 17:03:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:17586 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112AbYHaVDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 17:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=e75LFpRgXFL/PnEP3LiJlMazWrIOD1vxgh6qHu2+AE5FaFI76YnqcHe1kEsrTK+OlK
         pQAiYrp8Z/s6XAyDhELihpkwIEKca3n2Nz9suxduLcccXSOzUWnz2au4Jrf4ed0m99jj
         aQkAonlCLVCc6TSlvWrI/7DB5PZYzmr7ErsAA=
Message-ID: <86802c440808311403y57ba050q223fbe370d2c7675@mail.gmail.com>
Date: Sun, 31 Aug 2008 14:03:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808311100520.12958@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_23139_6993983.1220216603530"
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808302334.29156.rjw@sisk.pl>
	 <86802c440808301810r17657f3fnb3c8af5496955e0d@mail.gmail.com>
	 <200808311427.19369.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808311039330.12958@nehalem.linux-foundation.org>
	 <86802c440808311054q4b8e8921qa9f090527b456e34@mail.gmail.com>
	 <alpine.LFD.1.10.0808311100520.12958@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_23139_6993983.1220216603530
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Aug 31, 2008 at 11:03 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sun, 31 Aug 2008, Yinghai Lu wrote:
>>
>> wonder how the probe could find out the size of is 1fff_ffff..
>
> Heh. That's how PCI sizing works: you write all ones to the register, and
> read back the result. The low bits won't change, and that indicates the
> size.
>
> But if _none_ of the bits change, then that simply means that the size
> will be calculated to be 0xffffffff-start.
>
> So the sizing will "work", it will just always report that the BAR covers
> everything from start to the 4G limit.

how about


diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cce2f4c..3b5269a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -240,6 +240,11 @@ static int __pci_read_base(struct pci_dev *dev,
enum pci_bar_type type,
        pci_read_config_dword(dev, pos, &l);
        pci_write_config_dword(dev, pos, mask);
        pci_read_config_dword(dev, pos, &sz);
+
+       /* sticky and non changable */
+       if (sz == l)
+               goto fail;
+
        pci_write_config_dword(dev, pos, l);

        /*


Rafael,

can you check attach one  to see if we still have warning ?

YH

------=_Part_23139_6993983.1220216603530
Content-Type: text/x-patch; name=sticky_bar.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkk5d8xo0
Content-Disposition: attachment; filename=sticky_bar.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3Byb2JlLmMgYi9kcml2ZXJzL3BjaS9wcm9iZS5jCmlu
ZGV4IGNjZTJmNGMuLjNiNTI2OWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNpL3Byb2JlLmMKKysr
IGIvZHJpdmVycy9wY2kvcHJvYmUuYwpAQCAtMjQwLDYgKzI0MCwxMSBAQCBzdGF0aWMgaW50IF9f
cGNpX3JlYWRfYmFzZShzdHJ1Y3QgcGNpX2RldiAqZGV2LCBlbnVtIHBjaV9iYXJfdHlwZSB0eXBl
LAogCXBjaV9yZWFkX2NvbmZpZ19kd29yZChkZXYsIHBvcywgJmwpOwogCXBjaV93cml0ZV9jb25m
aWdfZHdvcmQoZGV2LCBwb3MsIG1hc2spOwogCXBjaV9yZWFkX2NvbmZpZ19kd29yZChkZXYsIHBv
cywgJnN6KTsKKworCS8qIHN0aWNreSBhbmQgbm9uIGNoYW5nYWJsZSAqLworCWlmIChzeiA9PSBs
KQorCQlnb3RvIGZhaWw7CisKIAlwY2lfd3JpdGVfY29uZmlnX2R3b3JkKGRldiwgcG9zLCBsKTsK
IAogCS8qCg==
------=_Part_23139_6993983.1220216603530--
