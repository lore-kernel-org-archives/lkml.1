Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZKWUXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZKWUXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 15:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbZKWUXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 15:23:44 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34989 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbZKWUXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 15:23:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=YzJmwEvT2kJIAlaITa+JI22TfH4vtmy6fcMG8/twtpoA7E7LnCEllyW0SXewD25BPQ
         MgI/tot1UIcPuyYfHA1YksBbFGmp5QyuqZbOasVtb8BMEZeOI4KyGCSj35SIkUZvNiTh
         ZO2H60LAJCwI1xmqzy0GnnJJqlcJmDmrBznas=
Message-ID: <4B0AEF4E.8070005@gmail.com>
Date: Mon, 23 Nov 2009 21:23:42 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] vt: Don't exceed max_font_size on copy in con_font_get()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

font.data is kmallocd with max_font_size (defined 65536). Below occurs a
copy_to_user with `c' as a size argument. Ensure we don't copy too much.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/char/vt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

If it is possible for c to be greater than 65536 then I think we may need this.
Correct?

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 0c80c68..045af83 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -3861,6 +3861,10 @@ static int con_font_get(struct vc_data *vc, struct console_font_op *op)
 		goto out;
 
 	c = (font.width+7)/8 * 32 * font.charcount;
+	if (c > max_font_size) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	if (op->data && font.charcount > op->charcount)
 		rc = -ENOSPC;
