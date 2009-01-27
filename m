Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZA0AaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZA0AaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZA0A36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:29:58 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:40619 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZA0A36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:29:58 -0500
MIME-Version: 1.0
In-Reply-To: <20090125224625.96429d3d.akpm@linux-foundation.org>
References: <877i4rjw38.fsf@tac.ki.iif.hu>
	 <20090125224625.96429d3d.akpm@linux-foundation.org>
Date: Mon, 26 Jan 2009 16:29:55 -0800
Message-ID: <d6200be20901261629y2e3d8804h16055b9497125371@mail.gmail.com>
Subject: Re: 2.6.29-rc2 dies on startup
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ferenc Wagner <wferi@niif.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2009 at 10:46 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> At a guess I'd say that drivers/staging/android/ram_console.c is calling
> the reed-solomon code earlier than it's expecting.  But that might be
> totally wrong.

Yes, but it also is trying to use a zero sized buffer at virtual
address 0 so it will not work much better if you turn off ecc.

This patch (to the android kernel tree) add some validation:
----
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0ce27ab..b226ccc 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -525,7 +525,6 @@ menuconfig ANDROID_RAM_CONSOLE_ERROR_CORRECTION
         bool "Enable error correction"
         default n
         depends on ANDROID_RAM_CONSOLE
-        depends on !ANDROID_RAM_CONSOLE_EARLY_INIT
         select REED_SOLOMON
         select REED_SOLOMON_ENC8
         select REED_SOLOMON_DEC8
diff --git a/drivers/misc/ram_console.c b/drivers/misc/ram_console.c
index 2a1274b..aec20f7 100644
--- a/drivers/misc/ram_console.c
+++ b/drivers/misc/ram_console.c
@@ -224,23 +224,9 @@ static int __init ram_console_init(struct
ram_console_buffer *buffer,
        ram_console_buffer_size =
                buffer_size - sizeof(struct ram_console_buffer);

-       if (ram_console_buffer_size > buffer_size) {
-               pr_err("ram_console: buffer %p, invalid size %d, datasize %d\n",
-                      buffer, buffer_size, ram_console_buffer_size);
-               return 0;
-       }
-
-
 #ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
        ram_console_buffer_size -= (DIV_ROUND_UP(ram_console_buffer_size,
                                                ECC_BLOCK_SIZE) + 1) * ECC_SIZE;
-       if (ram_console_buffer_size > buffer_size) {
-               pr_err("ram_console: buffer %p, invalid size %d, "
-                      "non-ecc datasize %d\n",
-                      buffer, buffer_size, ram_console_buffer_size);
-               return 0;
-       }
-
        ram_console_par_buffer = buffer->data + ram_console_buffer_size;


----

-- 
Arve Hjønnevåg
