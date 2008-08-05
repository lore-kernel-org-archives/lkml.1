Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbYHELpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbYHELpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbYHELpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:45:01 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:23894 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121AbYHELo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=Hw9YyFfjGdrz4xRMiixXuFNhchnL9oq91nbEayT/EaIUsfjpaEgE00q4nKvqQHKlab
         +Xa2SeK4iy7lP2a7vusmb+s7DPvhKMUtn5S2wSF949AF534DF7jLReTUPUukeh2Dvm8H
         IoY8lN1GUQGi8tvxh7CvLzAgymZgaKBvPMi7A=
Message-ID: <87a5b0800808050444t49480549t758f954c40139c4a@mail.gmail.com>
Date: Tue, 5 Aug 2008 12:44:58 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Alex Williamson" <alex.williamson@hp.com>
Subject: Re: [PATCH] serial 8250: tighten test for using backup timer
Cc: linux-serial <linux-serial@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Thomas Koeller" <thomas@koeller.dyndns.org>
In-Reply-To: <1205945437.6881.13.camel@lappy>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2907_21877159.1217936698367"
References: <1205945437.6881.13.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_2907_21877159.1217936698367
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Mar 19, 2008 at 5:50 PM, Alex Williamson <alex.williamson@hp.com> wrote:
> Hi,
>
>   Thomas Koeller had reported an issue where a device that had been
> making use of the UART_BUG_TXEN code in the 8250 driver was mistakenly
> being caught by the backup timer test, causing the device to work
> improperly.  To fix this, the patch below tightens the test requirements
> to enable the backup timer workaround.  The backup timer is really meant
> to catch UARTs that don't re-assert the THRE interrupt.  The expectation
> is that they do initially assert THRE.  This patch clarifies the test.
> Thanks,

Hi,

Sorry to not have picked up on this earlier, but this change seems to
break an old DesignWare UART I have in an SoC here. It has a number of
known issues, one of which is it does not appropriately reassert THRE.

What seems to happen is that the first time the port is opened the
code tests for incorrect reassertion of THRE and correctly sets up the
backup timer. The port is closed and subsequently reopened and this
time around the new logic prevents the backup timer from being
enabled. I'm not 100% sure of the details of the bug that is being
worked around here, but it appears that the second time the port is
opened it is not possible to detect the bug because the previous THRE
condition has already been acknowledged.

The attached patch fixes the problem for me and attempts to preserve
the new behaviour at the same time. Comments?

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 342e12f..e2eacdf 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1908,14 +1908,18 @@ static int serial8250_startup(struct uart_port *port)
 		 * kick the UART on a regular basis.
 		 */
 		if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
+			up->bugs |= UART_BUG_THRE;
 			pr_debug("ttyS%d - using backup timer\n", port->line);
-			up->timer.function = serial8250_backup_timeout;
-			up->timer.data = (unsigned long)up;
-			mod_timer(&up->timer, jiffies +
-				poll_timeout(up->port.timeout) + HZ / 5);
 		}
 	}

+	if (up->bugs & UART_BUG_THRE) {
+		up->timer.function = serial8250_backup_timeout;
+		up->timer.data = (unsigned long)up;
+		mod_timer(&up->timer, jiffies +
+			  poll_timeout(up->port.timeout) + HZ / 5);
+	}
+
 	/*
 	 * If the "interrupt" for this port doesn't correspond with any
 	 * hardware interrupt, we use a timer-based system.  The original
diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
index 78c0016..5202603 100644
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -47,6 +47,7 @@ struct serial8250_config {
 #define UART_BUG_QUOT	(1 << 0)	/* UART has buggy quot LSB */
 #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
 #define UART_BUG_NOMSR	(1 << 2)	/* UART has buggy MSR status bits (Au1x00) */
+#define UART_BUG_THRE	(1 << 3)	/* UART has buggy THRE reassertion */

 #define PROBE_RSA	(1 << 0)
 #define PROBE_ANY	(~0)


>        Alex
>
> Signed-off-by: Alex Williamson <alex.williamson@hp.com>
> ---
>
> diff -r 2202c155b8c3 drivers/serial/8250.c
> --- a/drivers/serial/8250.c     Tue Mar 18 21:34:48 2008 -0700
> +++ b/drivers/serial/8250.c     Wed Mar 19 10:32:40 2008 -0600
> @@ -1814,6 +1814,7 @@ static int serial8250_startup(struct uar
>        }
>
>        if (is_real_interrupt(up->port.irq)) {
> +               unsigned char iir1;
>                /*
>                 * Test for UARTs that do not reassert THRE when the
>                 * transmitter is idle and the interrupt has already
> @@ -1827,7 +1828,7 @@ static int serial8250_startup(struct uar
>                wait_for_xmitr(up, UART_LSR_THRE);
>                serial_out_sync(up, UART_IER, UART_IER_THRI);
>                udelay(1); /* allow THRE to set */
> -               serial_in(up, UART_IIR);
> +               iir1 = serial_in(up, UART_IIR);
>                serial_out(up, UART_IER, 0);
>                serial_out_sync(up, UART_IER, UART_IER_THRI);
>                udelay(1); /* allow a working UART time to re-assert THRE */
> @@ -1840,7 +1841,7 @@ static int serial8250_startup(struct uar
>                 * If the interrupt is not reasserted, setup a timer to
>                 * kick the UART on a regular basis.
>                 */
> -               if (iir & UART_IIR_NO_INT) {
> +               if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
>                        pr_debug("ttyS%d - using backup timer\n", port->line);
>                        up->timer.function = serial8250_backup_timeout;
>                        up->timer.data = (unsigned long)up;
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

------=_Part_2907_21877159.1217936698367
Content-Type: text/x-patch; name=serial-thre.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjifzyrj0
Content-Disposition: attachment; filename=serial-thre.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2VyaWFsLzgyNTAuYyBiL2RyaXZlcnMvc2VyaWFsLzgyNTAu
YwppbmRleCAzNDJlMTJmLi5lMmVhY2RmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3NlcmlhbC84MjUw
LmMKKysrIGIvZHJpdmVycy9zZXJpYWwvODI1MC5jCkBAIC0xOTA4LDE0ICsxOTA4LDE4IEBAIHN0
YXRpYyBpbnQgc2VyaWFsODI1MF9zdGFydHVwKHN0cnVjdCB1YXJ0X3BvcnQgKnBvcnQpCiAJCSAq
IGtpY2sgdGhlIFVBUlQgb24gYSByZWd1bGFyIGJhc2lzLgogCQkgKi8KIAkJaWYgKCEoaWlyMSAm
IFVBUlRfSUlSX05PX0lOVCkgJiYgKGlpciAmIFVBUlRfSUlSX05PX0lOVCkpIHsKKwkJCXVwLT5i
dWdzIHw9IFVBUlRfQlVHX1RIUkU7CiAJCQlwcl9kZWJ1ZygidHR5UyVkIC0gdXNpbmcgYmFja3Vw
IHRpbWVyXG4iLCBwb3J0LT5saW5lKTsKLQkJCXVwLT50aW1lci5mdW5jdGlvbiA9IHNlcmlhbDgy
NTBfYmFja3VwX3RpbWVvdXQ7Ci0JCQl1cC0+dGltZXIuZGF0YSA9ICh1bnNpZ25lZCBsb25nKXVw
OwotCQkJbW9kX3RpbWVyKCZ1cC0+dGltZXIsIGppZmZpZXMgKwotCQkJCXBvbGxfdGltZW91dCh1
cC0+cG9ydC50aW1lb3V0KSArIEhaIC8gNSk7CiAJCX0KIAl9CiAKKwlpZiAodXAtPmJ1Z3MgJiBV
QVJUX0JVR19USFJFKSB7CisJCXVwLT50aW1lci5mdW5jdGlvbiA9IHNlcmlhbDgyNTBfYmFja3Vw
X3RpbWVvdXQ7CisJCXVwLT50aW1lci5kYXRhID0gKHVuc2lnbmVkIGxvbmcpdXA7CisJCW1vZF90
aW1lcigmdXAtPnRpbWVyLCBqaWZmaWVzICsKKwkJCSAgcG9sbF90aW1lb3V0KHVwLT5wb3J0LnRp
bWVvdXQpICsgSFogLyA1KTsKKwl9CisKIAkvKgogCSAqIElmIHRoZSAiaW50ZXJydXB0IiBmb3Ig
dGhpcyBwb3J0IGRvZXNuJ3QgY29ycmVzcG9uZCB3aXRoIGFueQogCSAqIGhhcmR3YXJlIGludGVy
cnVwdCwgd2UgdXNlIGEgdGltZXItYmFzZWQgc3lzdGVtLiAgVGhlIG9yaWdpbmFsCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3NlcmlhbC84MjUwLmggYi9kcml2ZXJzL3NlcmlhbC84MjUwLmgKaW5kZXgg
NzhjMDAxNi4uNTIwMjYwMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zZXJpYWwvODI1MC5oCisrKyBi
L2RyaXZlcnMvc2VyaWFsLzgyNTAuaApAQCAtNDcsNiArNDcsNyBAQCBzdHJ1Y3Qgc2VyaWFsODI1
MF9jb25maWcgewogI2RlZmluZSBVQVJUX0JVR19RVU9UCSgxIDw8IDApCS8qIFVBUlQgaGFzIGJ1
Z2d5IHF1b3QgTFNCICovCiAjZGVmaW5lIFVBUlRfQlVHX1RYRU4JKDEgPDwgMSkJLyogVUFSVCBo
YXMgYnVnZ3kgVFggSUlSIHN0YXR1cyAqLwogI2RlZmluZSBVQVJUX0JVR19OT01TUgkoMSA8PCAy
KQkvKiBVQVJUIGhhcyBidWdneSBNU1Igc3RhdHVzIGJpdHMgKEF1MXgwMCkgKi8KKyNkZWZpbmUg
VUFSVF9CVUdfVEhSRQkoMSA8PCAzKQkvKiBVQVJUIGhhcyBidWdneSBUSFJFIHJlYXNzZXJ0aW9u
ICovCiAKICNkZWZpbmUgUFJPQkVfUlNBCSgxIDw8IDApCiAjZGVmaW5lIFBST0JFX0FOWQkofjAp
Cg==
------=_Part_2907_21877159.1217936698367--
