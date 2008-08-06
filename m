Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbYHFKxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbYHFKxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbYHFKxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:53:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:30547 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbYHFKxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=I0+HoP4auZdYUghZ4oCJvjLzbvIbleMD/XV3WTrsMWF0sEX4GNkdnPhguCdGKQE929
         F/ZVU8tmF1jJjl2DmkO/YqZ9hE1LLM706QEcrrWauO37KGJZiEAPKOVndUq+DdqrxnHv
         kZeykZ6pyka+FfzBUDn0HiTxMrNiL3BEMyFNA=
Message-ID: <87a5b0800808060353v505c4957wbd26aaa9a2624786@mail.gmail.com>
Date: Wed, 6 Aug 2008 11:53:13 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Alex Williamson" <alex.williamson@hp.com>
Subject: Re: [PATCH] serial 8250: tighten test for using backup timer
Cc: linux-serial <linux-serial@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Thomas Koeller" <thomas@koeller.dyndns.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1217966803.17091.72.camel@2710p.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_20760_22359829.1218019993263"
References: <1205945437.6881.13.camel@lappy>
	 <87a5b0800808050444t49480549t758f954c40139c4a@mail.gmail.com>
	 <1217966803.17091.72.camel@2710p.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_20760_22359829.1218019993263
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Aug 5, 2008 at 9:06 PM, Alex Williamson <alex.williamson@hp.com> wrote:
> Hi Will,
>
> On Tue, 2008-08-05 at 12:44 +0100, Will Newton wrote:
>> Hi,
>>
>> Sorry to not have picked up on this earlier, but this change seems to
>> break an old DesignWare UART I have in an SoC here. It has a number of
>> known issues, one of which is it does not appropriately reassert THRE.
>>
>> What seems to happen is that the first time the port is opened the
>> code tests for incorrect reassertion of THRE and correctly sets up the
>> backup timer. The port is closed and subsequently reopened and this
>> time around the new logic prevents the backup timer from being
>> enabled. I'm not 100% sure of the details of the bug that is being
>> worked around here, but it appears that the second time the port is
>> opened it is not possible to detect the bug because the previous THRE
>> condition has already been acknowledged.
>>
>> The attached patch fixes the problem for me and attempts to preserve
>> the new behaviour at the same time. Comments?
>
> It would be nice if there was a simple procedure we could do on the UART
> to reset it to a state so the test works repeatedly.  However, with all
> the buggy UARTs out there, that could end up disturbing someone else.
>
> This change works for me, though it is using up a bit in the bugs field;
> not that we seem to be allocating them at any great rate.  I think it
> would be worthy of a comment in the code to understand why this new
> block exists outside the test so we don't need to refer back to the
> commit changeset.
>
> Acked-by: Alex Williamson <alex.williamson@hp.com>

I've added a comment and your ack, thanks.

Andrew: Are you the appropriate person to send patches for the serial
subsystem to?

>From 36ac82a231498247ada098d31e8d12e735eb34f2 Mon Sep 17 00:00:00 2001
From: Will Newton <will.newton@gmail.com>
Date: Wed, 6 Aug 2008 11:48:29 +0100
Subject: [PATCH] 8250: Improve workaround for UARTs that don't
re-assert THRE correctly.

Recent changes to tighten the check for UARTs that don't correctly
re-assert THRE caused problems when such a UART was opened for the second
time - the bug could only successfully be detected at first initialization.
This patch stores the information about the bug in the bugs field of the
port structure when the port is first started up so subsequent opens can
check this bit even if the test for the bug fails.

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Alex Williamson <alex.williamson@hp.com>

---
 drivers/serial/8250.c |   16 ++++++++++++----
 drivers/serial/8250.h |    1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 342e12f..9ccc563 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1908,15 +1908,23 @@ static int serial8250_startup(struct uart_port *port)
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

 	/*
+	 * The above check will only give an accurate result the first time
+	 * the port is opened so this value needs to be preserved.
+	 */
+	if (up->bugs & UART_BUG_THRE) {
+		up->timer.function = serial8250_backup_timeout;
+		up->timer.data = (unsigned long)up;
+		mod_timer(&up->timer, jiffies +
+			  poll_timeout(up->port.timeout) + HZ / 5);
+	}
+
+	/*
 	 * If the "interrupt" for this port doesn't correspond with any
 	 * hardware interrupt, we use a timer-based system.  The original
 	 * driver used to do this with IRQ0.
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
-- 
1.5.5.2

------=_Part_20760_22359829.1218019993263
Content-Type: text/x-patch;
 name=0001-8250-Improve-workaround-for-UARTs-that-don-t-re-ass.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjjtlaj30
Content-Disposition: attachment;
 filename=0001-8250-Improve-workaround-for-UARTs-that-don-t-re-ass.patch

RnJvbSAzNmFjODJhMjMxNDk4MjQ3YWRhMDk4ZDMxZThkMTJlNzM1ZWIzNGYyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBXZWQsIDYgQXVnIDIwMDggMTE6NDg6MjkgKzAxMDAKU3ViamVjdDogW1BBVENIXSA4MjUw
OiBJbXByb3ZlIHdvcmthcm91bmQgZm9yIFVBUlRzIHRoYXQgZG9uJ3QgcmUtYXNzZXJ0IFRIUkUg
Y29ycmVjdGx5LgoKUmVjZW50IGNoYW5nZXMgdG8gdGlnaHRlbiB0aGUgY2hlY2sgZm9yIFVBUlRz
IHRoYXQgZG9uJ3QgY29ycmVjdGx5CnJlLWFzc2VydCBUSFJFIGNhdXNlZCBwcm9ibGVtcyB3aGVu
IHN1Y2ggYSBVQVJUIHdhcyBvcGVuZWQgZm9yIHRoZSBzZWNvbmQKdGltZSAtIHRoZSBidWcgY291
bGQgb25seSBzdWNjZXNzZnVsbHkgYmUgZGV0ZWN0ZWQgYXQgZmlyc3QgaW5pdGlhbGl6YXRpb24u
ClRoaXMgcGF0Y2ggc3RvcmVzIHRoZSBpbmZvcm1hdGlvbiBhYm91dCB0aGUgYnVnIGluIHRoZSBi
dWdzIGZpZWxkIG9mIHRoZQpwb3J0IHN0cnVjdHVyZSB3aGVuIHRoZSBwb3J0IGlzIGZpcnN0IHN0
YXJ0ZWQgdXAgc28gc3Vic2VxdWVudCBvcGVucyBjYW4KY2hlY2sgdGhpcyBiaXQgZXZlbiBpZiB0
aGUgdGVzdCBmb3IgdGhlIGJ1ZyBmYWlscy4KClNpZ25lZC1vZmYtYnk6IFdpbGwgTmV3dG9uIDx3
aWxsLm5ld3RvbkBnbWFpbC5jb20+CkFja2VkLWJ5OiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2ls
bGlhbXNvbkBocC5jb20+CgotLS0KIGRyaXZlcnMvc2VyaWFsLzgyNTAuYyB8ICAgMTYgKysrKysr
KysrKysrLS0tLQogZHJpdmVycy9zZXJpYWwvODI1MC5oIHwgICAgMSArCiAyIGZpbGVzIGNoYW5n
ZWQsIDEzIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zZXJpYWwvODI1MC5jIGIvZHJpdmVycy9zZXJpYWwvODI1MC5jCmluZGV4IDM0MmUxMmYuLjlj
Y2M1NjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2VyaWFsLzgyNTAuYworKysgYi9kcml2ZXJzL3Nl
cmlhbC84MjUwLmMKQEAgLTE5MDgsMTUgKzE5MDgsMjMgQEAgc3RhdGljIGludCBzZXJpYWw4MjUw
X3N0YXJ0dXAoc3RydWN0IHVhcnRfcG9ydCAqcG9ydCkKIAkJICoga2ljayB0aGUgVUFSVCBvbiBh
IHJlZ3VsYXIgYmFzaXMuCiAJCSAqLwogCQlpZiAoIShpaXIxICYgVUFSVF9JSVJfTk9fSU5UKSAm
JiAoaWlyICYgVUFSVF9JSVJfTk9fSU5UKSkgeworCQkJdXAtPmJ1Z3MgfD0gVUFSVF9CVUdfVEhS
RTsKIAkJCXByX2RlYnVnKCJ0dHlTJWQgLSB1c2luZyBiYWNrdXAgdGltZXJcbiIsIHBvcnQtPmxp
bmUpOwotCQkJdXAtPnRpbWVyLmZ1bmN0aW9uID0gc2VyaWFsODI1MF9iYWNrdXBfdGltZW91dDsK
LQkJCXVwLT50aW1lci5kYXRhID0gKHVuc2lnbmVkIGxvbmcpdXA7Ci0JCQltb2RfdGltZXIoJnVw
LT50aW1lciwgamlmZmllcyArCi0JCQkJcG9sbF90aW1lb3V0KHVwLT5wb3J0LnRpbWVvdXQpICsg
SFogLyA1KTsKIAkJfQogCX0KIAogCS8qCisJICogVGhlIGFib3ZlIGNoZWNrIHdpbGwgb25seSBn
aXZlIGFuIGFjY3VyYXRlIHJlc3VsdCB0aGUgZmlyc3QgdGltZQorCSAqIHRoZSBwb3J0IGlzIG9w
ZW5lZCBzbyB0aGlzIHZhbHVlIG5lZWRzIHRvIGJlIHByZXNlcnZlZC4KKwkgKi8KKwlpZiAodXAt
PmJ1Z3MgJiBVQVJUX0JVR19USFJFKSB7CisJCXVwLT50aW1lci5mdW5jdGlvbiA9IHNlcmlhbDgy
NTBfYmFja3VwX3RpbWVvdXQ7CisJCXVwLT50aW1lci5kYXRhID0gKHVuc2lnbmVkIGxvbmcpdXA7
CisJCW1vZF90aW1lcigmdXAtPnRpbWVyLCBqaWZmaWVzICsKKwkJCSAgcG9sbF90aW1lb3V0KHVw
LT5wb3J0LnRpbWVvdXQpICsgSFogLyA1KTsKKwl9CisKKwkvKgogCSAqIElmIHRoZSAiaW50ZXJy
dXB0IiBmb3IgdGhpcyBwb3J0IGRvZXNuJ3QgY29ycmVzcG9uZCB3aXRoIGFueQogCSAqIGhhcmR3
YXJlIGludGVycnVwdCwgd2UgdXNlIGEgdGltZXItYmFzZWQgc3lzdGVtLiAgVGhlIG9yaWdpbmFs
CiAJICogZHJpdmVyIHVzZWQgdG8gZG8gdGhpcyB3aXRoIElSUTAuCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3NlcmlhbC84MjUwLmggYi9kcml2ZXJzL3NlcmlhbC84MjUwLmgKaW5kZXggNzhjMDAxNi4u
NTIwMjYwMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zZXJpYWwvODI1MC5oCisrKyBiL2RyaXZlcnMv
c2VyaWFsLzgyNTAuaApAQCAtNDcsNiArNDcsNyBAQCBzdHJ1Y3Qgc2VyaWFsODI1MF9jb25maWcg
ewogI2RlZmluZSBVQVJUX0JVR19RVU9UCSgxIDw8IDApCS8qIFVBUlQgaGFzIGJ1Z2d5IHF1b3Qg
TFNCICovCiAjZGVmaW5lIFVBUlRfQlVHX1RYRU4JKDEgPDwgMSkJLyogVUFSVCBoYXMgYnVnZ3kg
VFggSUlSIHN0YXR1cyAqLwogI2RlZmluZSBVQVJUX0JVR19OT01TUgkoMSA8PCAyKQkvKiBVQVJU
IGhhcyBidWdneSBNU1Igc3RhdHVzIGJpdHMgKEF1MXgwMCkgKi8KKyNkZWZpbmUgVUFSVF9CVUdf
VEhSRQkoMSA8PCAzKQkvKiBVQVJUIGhhcyBidWdneSBUSFJFIHJlYXNzZXJ0aW9uICovCiAKICNk
ZWZpbmUgUFJPQkVfUlNBCSgxIDw8IDApCiAjZGVmaW5lIFBST0JFX0FOWQkofjApCi0tIAoxLjUu
NS4yCgo=
------=_Part_20760_22359829.1218019993263--
