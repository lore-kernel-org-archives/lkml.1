Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab0BCCx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 21:53:57 -0500
Received: from n76.bullet.mail.sp1.yahoo.com ([98.136.44.48]:32334 "HELO
	n76.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755435Ab0BCCxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 21:53:55 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 782746.8861.bm@omp611.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ameritech.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=yjp1PGvvYfvsnxEPPxZU+Rr9bCkoudHglTeT9YdYowKlyDdCzk0vRbWhVCw/zYFW72T6bHLDQkCKx56cV9eH3wRkQF2euuRaMCzV6PZoxXYcL+s9fvF2AQBrAVd+8wRm0/Hm6OLA4/27JKslMxdWz0CqgEQJhRgWNOAarR+KXY0=;
Message-ID: <629563.51563.qm@web180707.mail.sp1.yahoo.com>
X-YMail-OSG: mZgR6vQVM1lkHBwDAQXHbobJfwqgj..7r5.NBclDh2tCpdQ.QbJ6mCHiw8vwxIthI2JLS_MzIgYr7J.app_Gj9o2utmP9heow5B4RPGrrY6QXeIz1ZAPd9FCEQpWDO.fegesM3FE2jjRGc8Y_gTRYZwlkQaJ_LJXGdwrXfRxL.OeR23C9tBSS8YWjRfsuQ1H2pf_A9gc3FagIU4wiQo1LrN5rj.K8GCFW._nGY7N4kPRZ92ojspQYIVdF0oW8OTWqkaTxLRYwzl4CuxAVzcdUDOtZBYi63bMfnnrP98xuSXtroBWYlzI1UbKeYryvqYFb4mHJFwmiLgT1BAvTaFTfFjjy7tPjlLwHAMXFhvalMroPjcddftFHdxAT3oeHUD2eN4raQ--
X-Mailer: YahooMailRC/272.7 YahooMailWebService/0.8.100.260964
References: <73211.74714.qm@web180714.mail.sp1.yahoo.com> <4B684513.8090201@ladisch.de> <20100202230911.71e8b600@Jay>
Date: Tue, 2 Feb 2010 18:53:54 -0800 (PST)
From: Frederick V Heitkamp <heitkamp@ameritech.net>
Subject: Re: [alsa-devel] Crash 2.6.32.x, Echo 3G, Alsa, SCSI
To: Giuliano Pochini <pochini@shiny.it>, Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
In-Reply-To: <20100202230911.71e8b600@Jay>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is another possible fix. I tested it briefly. It looks ok wrt race
conditions because pipe->state is set only in the trigger callback. I hope
I didn't overlook anything again...


Signed-off-by: Giuliano Pochini <pochini@shiny.it>

--- alsa-driver-1.0.22.1/alsa-kernel/pci/echoaudio/echoaudio.c__orig    2010-02-02 22:37:33.000000000 +0100
+++ alsa-driver-1.0.22.1/alsa-kernel/pci/echoaudio/echoaudio.c    2010-02-02 22:44:03.000000000 +0100
@@ -1821,7 +1821,9 @@ static irqreturn_t snd_echo_interrupt(in
    /* The hardware doesn't tell us which substream caused the irq,
    thus we have to check all running substreams. */
    for (ss = 0; ss < DSP_MAXPIPES; ss++) {
-        if ((substream = chip->substream[ss])) {
+        substream = chip->substream[ss];
+        if (substream && ((struct audiopipe *)substream->runtime->
+                private_data)->state == PIPE_STATE_STARTED) {
            period = pcm_pointer(substream) /
                substream->runtime->period_size;
            if (period != chip->last_period[ss]) {


-- 
Giuliano.


I am using this patch.  So far, no crash.


Fred

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


