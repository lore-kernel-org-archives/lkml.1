Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYFWXLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYFWXLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbYFWXIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:08:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:30950 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbYFWXIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:08:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=n6YE1TyXvskoBcuVJKzXJUukefvD+tpBMxHreVUA+IqQv2lFFx/Y/0xfU7m9uUkWUq
         dKbTVeknasGTKZwYkwG0WAUbuBX5+Cw9wsz9x/X7nT+pP/eScFQh/EN03GZFi1Mxh8W0
         DXqFOhcs50GWs4b4/8ydFumsRB8dvFo1piuog=
Message-ID: <b1bc6a000806231608q2cc0bef2xe58719b27bd2a809@mail.gmail.com>
Date: Mon, 23 Jun 2008 16:08:06 -0700
From: "adam radford" <aradford@gmail.com>
To: "Christopher S. Aker" <caker@theshore.net>
Subject: Re: ext3 directory corruption under Xen
Cc: linux-kernel@vger.kernel.org, "xen devel" <xen-devel@lists.xensource.com>
In-Reply-To: <485FFF41.3000603@theshore.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_7141_14020836.1214262486093"
References: <485FCC25.7090401@theshore.net>
	 <b1bc6a000806231213p162cea21y37ed9ec1d3bb39fd@mail.gmail.com>
	 <485FFF41.3000603@theshore.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_7141_14020836.1214262486093
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Jun 23, 2008 at 12:53 PM, Christopher S. Aker
<caker@theshore.net> wrote:
> adam radford wrote:
>>
>> On Mon, Jun 23, 2008 at 9:15 AM, Christopher S. Aker <caker@theshore.net>
>> wrote:
>>
>>> It's happened on a number of different hosts, all of the same hardware
>>> and
>>> software configuration (Xen 3.2 64bit, 32bit pae dom0, 32bit pae domUs.
>>>  LVM
>>> backend with 3ware hardware RAID-1).
>
>>
>>
>> A driver patch for older kernels including XenServer-4.1 is available
>> here:
>>
>> http://www.3ware.com/KB/article.aspx?id=15243&cNode=6I1C6S
>
> Thanks, but unfortunately, from that link:
>
> "3ware 9000 series controllers are not affected by this issue."
>
> ... which is what we're using.  This problem only appeared after rebooting
> these machines into Xen.  Some of affected boxes even ran 2.6.18 (non Xen)
> for awhile without any problems.
>
> -Chris
>

I've seen cases where Xen DMA code (pci-dma-xen.c) sends I/O requests
un-necessarily through the SWIOTLB code.

Xen dma: avoid unnecessarily SWIOTLB bounce buffering:

http://lists.xensource.com/archives/html/xen-changelog/2008-04/msg00008.html

so you may need a similar bidirectional fix for the 3w-9xxx driver.

Can you try this patch (in-line below and also attached):

-Adam

diff -Naur linux-2.6.18-xen-3.2.0/drivers/scsi/3w-9xxx.c
linux-2.6.18-xen-3.2.0.new/drivers/scsi/3w-9xxx.c
--- linux-2.6.18-xen-3.2.0/drivers/scsi/3w-9xxx.c	2008-02-12
02:44:33.000000000 -0800
+++ linux-2.6.18-xen-3.2.0.new/drivers/scsi/3w-9xxx.c	2008-06-23
15:42:02.000000000 -0700
@@ -1388,7 +1388,7 @@
 	if (cmd->use_sg == 0)
 		goto out;

-	use_sg = pci_map_sg(pdev, cmd->request_buffer, cmd->use_sg,
DMA_BIDIRECTIONAL);
+	use_sg = pci_map_sg(pdev, cmd->request_buffer, cmd->use_sg,
cmd->sc_data_direction);

 	if (use_sg == 0) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to map scatter
gather list");
@@ -1415,7 +1415,7 @@
 		goto out;
 	}

-	mapping = pci_map_single(pdev, cmd->request_buffer,
cmd->request_bufflen, DMA_BIDIRECTIONAL);
+	mapping = pci_map_single(pdev, cmd->request_buffer,
cmd->request_bufflen, cmd->sc_data_direction);

 	if (mapping == 0) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1d, "Failed to map page");
@@ -1423,7 +1423,7 @@
 	}

 	cmd->SCp.phase = TW_PHASE_SINGLE;
-	cmd->SCp.have_data_in = mapping;
+	cmd->SCp.dma_handle = mapping;
 	retval = mapping;
 out:
 	return retval;
@@ -2000,10 +2000,10 @@

 	switch(cmd->SCp.phase) {
 	case TW_PHASE_SINGLE:
-		pci_unmap_single(pdev, cmd->SCp.have_data_in, cmd->request_bufflen,
DMA_BIDIRECTIONAL);
+		pci_unmap_single(pdev, cmd->SCp.dma_handle, cmd->request_bufflen,
cmd->sc_data_direction);
 		break;
 	case TW_PHASE_SGLIST:
-		pci_unmap_sg(pdev, cmd->request_buffer, cmd->use_sg, DMA_BIDIRECTIONAL);
+		pci_unmap_sg(pdev, cmd->request_buffer, cmd->use_sg, cmd->sc_data_direction);
 		break;
 	}
 } /* End twa_unmap_scsi_data() */

------=_Part_7141_14020836.1214262486093
Content-Type: text/x-patch; name=3w-9xxx_xen3.2.0.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fhtoet3n0
Content-Disposition: attachment; filename=3w-9xxx_xen3.2.0.patch

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMTgteGVuLTMuMi4wL2RyaXZlcnMvc2NzaS8zdy05eHh4LmMg
bGludXgtMi42LjE4LXhlbi0zLjIuMC5uZXcvZHJpdmVycy9zY3NpLzN3LTl4eHguYwotLS0gbGlu
dXgtMi42LjE4LXhlbi0zLjIuMC9kcml2ZXJzL3Njc2kvM3ctOXh4eC5jCTIwMDgtMDItMTIgMDI6
NDQ6MzMuMDAwMDAwMDAwIC0wODAwCisrKyBsaW51eC0yLjYuMTgteGVuLTMuMi4wLm5ldy9kcml2
ZXJzL3Njc2kvM3ctOXh4eC5jCTIwMDgtMDYtMjMgMTU6NDI6MDIuMDAwMDAwMDAwIC0wNzAwCkBA
IC0xMzg4LDcgKzEzODgsNyBAQAogCWlmIChjbWQtPnVzZV9zZyA9PSAwKQogCQlnb3RvIG91dDsK
IAotCXVzZV9zZyA9IHBjaV9tYXBfc2cocGRldiwgY21kLT5yZXF1ZXN0X2J1ZmZlciwgY21kLT51
c2Vfc2csIERNQV9CSURJUkVDVElPTkFMKTsKKwl1c2Vfc2cgPSBwY2lfbWFwX3NnKHBkZXYsIGNt
ZC0+cmVxdWVzdF9idWZmZXIsIGNtZC0+dXNlX3NnLCBjbWQtPnNjX2RhdGFfZGlyZWN0aW9uKTsK
IAogCWlmICh1c2Vfc2cgPT0gMCkgewogCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklW
RVIsIDB4MWMsICJGYWlsZWQgdG8gbWFwIHNjYXR0ZXIgZ2F0aGVyIGxpc3QiKTsKQEAgLTE0MTUs
NyArMTQxNSw3IEBACiAJCWdvdG8gb3V0OwogCX0KIAotCW1hcHBpbmcgPSBwY2lfbWFwX3Npbmds
ZShwZGV2LCBjbWQtPnJlcXVlc3RfYnVmZmVyLCBjbWQtPnJlcXVlc3RfYnVmZmxlbiwgRE1BX0JJ
RElSRUNUSU9OQUwpOworCW1hcHBpbmcgPSBwY2lfbWFwX3NpbmdsZShwZGV2LCBjbWQtPnJlcXVl
c3RfYnVmZmVyLCBjbWQtPnJlcXVlc3RfYnVmZmxlbiwgY21kLT5zY19kYXRhX2RpcmVjdGlvbik7
CiAKIAlpZiAobWFwcGluZyA9PSAwKSB7CiAJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RS
SVZFUiwgMHgxZCwgIkZhaWxlZCB0byBtYXAgcGFnZSIpOwpAQCAtMTQyMyw3ICsxNDIzLDcgQEAK
IAl9CiAKIAljbWQtPlNDcC5waGFzZSA9IFRXX1BIQVNFX1NJTkdMRTsKLQljbWQtPlNDcC5oYXZl
X2RhdGFfaW4gPSBtYXBwaW5nOworCWNtZC0+U0NwLmRtYV9oYW5kbGUgPSBtYXBwaW5nOwogCXJl
dHZhbCA9IG1hcHBpbmc7CiBvdXQ6CiAJcmV0dXJuIHJldHZhbDsKQEAgLTIwMDAsMTAgKzIwMDAs
MTAgQEAKIAogCXN3aXRjaChjbWQtPlNDcC5waGFzZSkgewogCWNhc2UgVFdfUEhBU0VfU0lOR0xF
OgotCQlwY2lfdW5tYXBfc2luZ2xlKHBkZXYsIGNtZC0+U0NwLmhhdmVfZGF0YV9pbiwgY21kLT5y
ZXF1ZXN0X2J1ZmZsZW4sIERNQV9CSURJUkVDVElPTkFMKTsKKwkJcGNpX3VubWFwX3NpbmdsZShw
ZGV2LCBjbWQtPlNDcC5kbWFfaGFuZGxlLCBjbWQtPnJlcXVlc3RfYnVmZmxlbiwgY21kLT5zY19k
YXRhX2RpcmVjdGlvbik7CiAJCWJyZWFrOwogCWNhc2UgVFdfUEhBU0VfU0dMSVNUOgotCQlwY2lf
dW5tYXBfc2cocGRldiwgY21kLT5yZXF1ZXN0X2J1ZmZlciwgY21kLT51c2Vfc2csIERNQV9CSURJ
UkVDVElPTkFMKTsKKwkJcGNpX3VubWFwX3NnKHBkZXYsIGNtZC0+cmVxdWVzdF9idWZmZXIsIGNt
ZC0+dXNlX3NnLCBjbWQtPnNjX2RhdGFfZGlyZWN0aW9uKTsKIAkJYnJlYWs7CiAJfQogfSAvKiBF
bmQgdHdhX3VubWFwX3Njc2lfZGF0YSgpICovCg==
------=_Part_7141_14020836.1214262486093--
