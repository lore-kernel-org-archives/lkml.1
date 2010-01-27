Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194Ab0A0OJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0A0OJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053Ab0A0OJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:09:39 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:49052 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755155Ab0A0OJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:09:38 -0500
Date: Wed, 27 Jan 2010 17:09:36 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Josh Boyer <jwboyer@gmail.com>,
       Stefani Seibold <stefani@seibold.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 2/3] USB: FHCI: Fix build after kfifo rework
Message-ID: <20100127140936.GB31608@oksana.dev.rtsoft.ru>
References: <20100127140809.GA27906@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100127140809.GA27906@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After kfifo rework FHCI fails to build:

  CC      drivers/usb/host/fhci-tds.o
drivers/usb/host/fhci-tds.c: In function 'fhci_ep0_free':
drivers/usb/host/fhci-tds.c:108: error: used struct type value where scalar is required
drivers/usb/host/fhci-tds.c:118: error: used struct type value where scalar is required
drivers/usb/host/fhci-tds.c:128: error: used struct type value where scalar is required

This is because kfifos are no longer pointers in the ep struct.
So, instead of checking the pointers, we should now check if kfifo
is initialized.

Reported-by: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/usb/host/fhci-tds.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/fhci-tds.c b/drivers/usb/host/fhci-tds.c
index d224ab4..e123289 100644
--- a/drivers/usb/host/fhci-tds.c
+++ b/drivers/usb/host/fhci-tds.c
@@ -105,7 +105,7 @@ void fhci_ep0_free(struct fhci_usb *usb)
 		if (ep->td_base)
 			cpm_muram_free(cpm_muram_offset(ep->td_base));
 
-		if (ep->conf_frame_Q) {
+		if (kfifo_initialized(&ep->conf_frame_Q)) {
 			size = cq_howmany(&ep->conf_frame_Q);
 			for (; size; size--) {
 				struct packet *pkt = cq_get(&ep->conf_frame_Q);
@@ -115,7 +115,7 @@ void fhci_ep0_free(struct fhci_usb *usb)
 			cq_delete(&ep->conf_frame_Q);
 		}
 
-		if (ep->empty_frame_Q) {
+		if (kfifo_initialized(&ep->empty_frame_Q)) {
 			size = cq_howmany(&ep->empty_frame_Q);
 			for (; size; size--) {
 				struct packet *pkt = cq_get(&ep->empty_frame_Q);
@@ -125,7 +125,7 @@ void fhci_ep0_free(struct fhci_usb *usb)
 			cq_delete(&ep->empty_frame_Q);
 		}
 
-		if (ep->dummy_packets_Q) {
+		if (kfifo_initialized(&ep->dummy_packets_Q)) {
 			size = cq_howmany(&ep->dummy_packets_Q);
 			for (; size; size--) {
 				u8 *buff = cq_get(&ep->dummy_packets_Q);
-- 
1.6.5.7

