Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbXHEPyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbXHEPyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXHEPyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:54:11 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:31093 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbXHEPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YT6Q0Q4PN8cpjvGneqwXxGvE//C6bRgcBdkep3hmwNq0dH6wxzzkmwLjXFpDnh/3gWhZGy3JMH9MTbSXA2/mB05Y4EYN4cleW7mXPJGBXVaromr/u/F9Y88RBNRnTzK+1sRqiAOGEQVgzaCuTAuGMHlCzw6TL0wSYCa2ml/4IkY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH][RESEND] Fix a potential NULL pointer deref in the aic7xxx, ahc_print_register() function
Date: Sun, 5 Aug 2007 17:52:05 +0200
User-Agent: KMail/1.9.7
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <jejb@kernel.org>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200708042030.52405.jesper.juhl@gmail.com> <9a8748490708050836m20b5dd38gf6a8968cd4b106f9@mail.gmail.com> <46B5EFE7.6090008@scsiguy.com>
In-Reply-To: <46B5EFE7.6090008@scsiguy.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708051752.06003.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 August 2007 17:42:31 Justin T. Gibbs wrote:
> All of this logic was simplified back in '05 in the BSD drivers by adding
> this to the top of the function:
> 
>         u_int   dummy_column;
>   
>         if (cur_column == NULL) {
>                 dummy_column = 0;
>                 cur_column = &dummy_column;
>         }
> 
> and then stripping out the cur_column == NULL checks in the routine.
> 

Thank you for that info.

James, if that sounds like a better way to deal with it to you, then 
here's a patch to implement it.



Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/aic7xxx/aic7xxx_core.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 75733b0..d1f3f25 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -6529,8 +6529,14 @@ ahc_print_register(ahc_reg_parse_entry_t *table, u_int num_entries,
 {
 	int	printed;
 	u_int	printed_mask;
+	u_int	dummy_column;
 
-	if (cur_column != NULL && *cur_column >= wrap_point) {
+	if (!cur_column) {
+		dummy_column = 0;
+		cur_column = &dummy_column;
+	}
+
+	if (*cur_column >= wrap_point) {
 		printf("\n");
 		*cur_column = 0;
 	}
@@ -6565,8 +6571,7 @@ ahc_print_register(ahc_reg_parse_entry_t *table, u_int num_entries,
 		printed += printf(") ");
 	else
 		printed += printf(" ");
-	if (cur_column != NULL)
-		*cur_column += printed;
+	*cur_column += printed;
 	return (printed);
 }
 


