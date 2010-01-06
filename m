Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540Ab0AFRAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0AFRAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932216Ab0AFRAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:00:45 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40043 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab0AFRAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Rca8YcYq59uz6RbnqSnrY6UI2hEViBFxLVyi43vCNOHHMlY5+o/G/ovVG+bz+776qr
         prybsx4SUdknCNIux6PgMt+DIocmd/DwVn4BxtYQPeimlsvhsbSyr7//B9oZZuRDDse3
         h3rXdVd7Yrow2tx8OH1ZIzgC/EG5I4fhkuumQ=
From: Johan Hovold <jhovold@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: James Simmons <jsimmons@infradead.org>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [bisected] drm/ksm: fbdev blanking regression in 2.6.33
Date: Wed,  6 Jan 2010 18:00:25 +0100
Message-Id: <1262797226-9593-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Console blanking broke on my laptop with GM45 chipset with 2.6.33. Instead of
blanking, the screen was dimmed and the backlight started glowing in the lower
edges of the screen. The glowing then slowly spread upwards. Did not look
healthy at all.

Easily reproduced by issuing "setterm -blank force".

I bisected it down to 731b5a15a3b1474a41c2ca29b4c32b0f21bc852e (drm/kms:
properly handle fbdev blanking). Which instead of going directly to
DPMS_STANDBY now calls the encoder dpms helper with DRM_MODE_DPMS_ON and the
crtc dpms helper with DRM_MODE_DPMS_OFF. I've verified that is this combination
that triggers the bug. 

If I don't call crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF) on FB_BLANK_NORMAL
but still encoder_funcs->dpms(encoder, DRM_MODE_DPMS_ON), the bug is not
triggered, but the screen is not cleared either.

For now, I simply reverted to the old behaviour of going directly to
DPMS_STANDBY (see follow-up patch).  

Thanks,
Johan


Johan Hovold (1):
  drm/kms: fix fbdev blanking regression

 drivers/gpu/drm/drm_fb_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

