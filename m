Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522Ab0BZX0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:26:44 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:45729 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab0BZX0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:26:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PphAsgl51IVUoQ0kH3JUU+OQYMRNmhc6CbQmOeSWEYNTTSiqCsnkYPzMjH+IYuA8eb
         GT1j9W83hE1Y1JxcFUb+5kv+KH5d68yGt+NyHMFMWNELuoSw+O6Xrg6m2e5sEJwTUa44
         w1hl4G8bjpjsSx4ml/KVLlhfHNFgKKCXr7TcM=
From: Ben Gardner <gardner.ben@gmail.com>
To: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Gardner <gardner.ben@gmail.com>
Subject: [PATCH 0/3] gpio: add gpio_set_direction
Date: Fri, 26 Feb 2010 17:26:23 -0600
Message-Id: <cover.1267225701.git.gardner.ben@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OLPC uses a GPIO output to enable/disable the MIC input.
The code uses gpio_get_value() to retrive the current MIC enabled status.
Due to a recent fix to cs5535-gpio, that function returns the input value.
Since the input is not enabled, the input value does not match the output.
gpiolib doesn't currently have the ability to enable both input and output. 
Nor does gpiolib have the ability to retrieve the current output value.

There are several ways to fix this MIC problem.
1) keep track of the output value in the audio driver and do not use
gpio_get_value().

2) add a new gpiolib function to retrieve the output value.                  

3) add a way to set the GPIO bidirectional, so the read retrieves the real
value that the MIC circuitry would see.

Since the CS5535 GPIO pins has independant control of the input and output,
I went with the last option.

This patchset merges the gpio_direction_input() and gpio_direction_output()
function into gpio_set_direction().                                 
The direction parameter is a bit field, so the direction can be one of
none, in, out, inout.
The cs5535-gpio driver is updated to support set_direction() and 
cs5535audio_olpc is updated to set the GPIO in bidirectional mode.

Ben Gardner (3):
  gpiolib: add gpio_set_direction()
  cs5535-gpio: Use set_direction
  OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input

 drivers/gpio/cs5535-gpio.c               |   34 ++++-----
 drivers/gpio/gpiolib.c                   |  123 +++++++++++++++---------------
 include/asm-generic/gpio.h               |    6 ++
 include/linux/gpio.h                     |    5 +
 sound/pci/cs5535audio/cs5535audio_olpc.c |    2 +-
 5 files changed, 89 insertions(+), 81 deletions(-)

