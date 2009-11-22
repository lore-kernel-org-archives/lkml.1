Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZKVOSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZKVOSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 09:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZKVOSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 09:18:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50949 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZKVOSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 09:18:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DnUoQwWY+WNniJF+T1YuUBsYgY1YiP7bOnLFVvLX3zjhO587CjJ4nbdNorZkYyXaOh
         l2V59kJHjArzY8hPs5uGMOqbAqOnfBGdpi8RK4HmDWO4T1w0fB15sudgI9/qlIdhWXvF
         TmF+DhyqvXw5/SIGoWe+1nn2SvxTZEUNdnN9k=
Message-ID: <4B094B46.8070901@gmail.com>
Date: Sun, 22 Nov 2009 15:31:34 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] e1000e: Use sizeof struct rather than pointer in e1000_get_eeprom()
References: <4B083EE2.9040301@gmail.com>
In-Reply-To: <4B083EE2.9040301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use the sizeof the pointer to clear the result

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/e1000e/ethtool.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

> -		memset(eeprom_buff, 0xff, sizeof(eeprom_buff));
> +		memset(eeprom_buff, 0xff, sizeof(*eeprom_buff));

No it's probably still not correct, eeprom_buff was kmalloc'd with:

eeprom_buff = kmalloc(sizeof(u16) *
                        (last_word - first_word + 1), GFP_KERNEL);

How about:

diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
index 1bf4d2a..5b276c0 100644
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -508,7 +508,8 @@ static int e1000_get_eeprom(struct net_device *netdev,
 
 	if (ret_val) {
 		/* a read error occurred, throw away the result */
-		memset(eeprom_buff, 0xff, sizeof(eeprom_buff));
+		memset(eeprom_buff, 0xff, sizeof(u16) *
+				(last_word - first_word + 1));
 	} else {
 		/* Device's eeprom is always little-endian, word addressable */
 		for (i = 0; i < last_word - first_word + 1; i++)
