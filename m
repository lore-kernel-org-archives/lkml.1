Return-Path: <linux-kernel-owner+w=401wt.eu-S1751634AbZJWM4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbZJWM4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 08:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZJWM4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 08:56:16 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:60539 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbZJWM4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 08:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=x2K9tBQJ1I6I0L5mGURmg5Yt9M35L0Becq8UAuut+MTJ4gE5dXFPIzGvPM6LsLTsGf
         U9b1YNKsGgMcc7fFQCiP0oOSx9dHpp1KI7umF7UqvtGujyLuoGsXEx1KVg0LU8wN1XFE
         ExerXa+8qQ1IQmZ5HtAJ1U07y6Yo8c/Xmgihk=
From: Stephane Eranian <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, paulus@samba.org, a.p.zijlstra@chello.nl,
       perfmon2-devel@lists.sf.net, Stephane Eranian <eranian@gmail.com>
Subject: [PATCH] perf_events: fix default watermark calculation
Date: Fri, 23 Oct 2009 14:56:16 +0200
Message-Id: <1256302576-6169-1-git-send-email-eranian@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch fixes the default watermark value for
	the sampling buffer. With the existing calculation
	(watermark = max(PAGE_SIZE, max_size / 2)), no
	notification was ever received when the buffer was
	exactly 1 page. This was because you would never
	cross the threshold (there is no partial samples).

	In certain configuration, there was no possibilty
	detecting the problem because there was not enough
	space left to store the LOST record.In fact, there
	may be a more generic problem here. The kernel should
	ensure that there is alaways enough space to store
	one LOST record.

	This patch sets the default watermark to half the
	buffer size. With such limit, we are guaranteed to
	get a notification even with a single page buffer
	assuming no sample is bigger than a page.
	
	Signed-off-by: Stephane Eranian <eranian@gmail.com>

---
 kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a69d4ed..e8ec4b7 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2315,7 +2315,7 @@ perf_mmap_data_init(struct perf_event *event, struct perf_mmap_data *data)
 	}
 
 	if (!data->watermark)
-		data->watermark = max_t(long, PAGE_SIZE, max_size / 2);
+		data->watermark = max_size / 2;
 
 
 	rcu_assign_pointer(event->data, data);
