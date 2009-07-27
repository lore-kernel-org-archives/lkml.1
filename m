Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbZG0P7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbZG0P7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZG0P7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:59:18 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35134 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZG0P7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:59:18 -0400
MIME-Version: 1.0
In-Reply-To: <1248707662-4060-1-git-send-email-adkulkar@umail.iu.edu>
References: <1248707662-4060-1-git-send-email-adkulkar@umail.iu.edu>
Date: Mon, 27 Jul 2009 09:59:18 -0600
Message-ID: <f6e1b7990907270859l65f84d8bm4712f6d82d9a688a@mail.gmail.com>
Subject: Re: [PATCH] net/9p: Insulate the client against an invalid error code 
	sent by a 9p server.
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding netdev to Cc.
---

A looney tunes server sending an invalid error code (which is !IS_ERR_VALUE)
can result in a client oops. So fix it by adding a check and converting unknown
or invalid error codes to -ESERVERFAULT.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 787ccdd... c9a5bf9... M	net/9p/client.c
:100644 100644 fdebe43... 5251851... M	net/9p/error.c
 net/9p/client.c |    7 +------
 net/9p/error.c  |    2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 787ccdd..c9a5bf9 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -411,14 +411,9 @@ static int p9_check_errors(struct p9_client *c,
struct p9_req_t *req)
 		if (c->dotu)
 			err = -ecode;

-		if (!err) {
+		if (!err || !IS_ERR_VALUE(err))
 			err = p9_errstr2errno(ename, strlen(ename));

-			/* string match failed */
-			if (!err)
-				err = -ESERVERFAULT;
-		}
-
 		P9_DPRINTK(P9_DEBUG_9P, "<<< RERROR (%d) %s\n", -ecode, ename);

 		kfree(ename);
diff --git a/net/9p/error.c b/net/9p/error.c
index fdebe43..5251851 100644
--- a/net/9p/error.c
+++ b/net/9p/error.c
@@ -239,7 +239,7 @@ int p9_errstr2errno(char *errstr, int len)
 		errstr[len] = 0;
 		printk(KERN_ERR "%s: server reported unknown error %s\n",
 			__func__, errstr);
-		errno = 1;
+		errno = ESERVERFAULT;
 	}

 	return -errno;
-- 
1.6.0.4


On Mon, Jul 27, 2009 at 9:14 AM, Abhishek Kulkarni<adkulkar@umail.iu.edu> wrote:
> A looney tunes server sending an invalid error code (which is !IS_ERR_VALUE)
> can result in a client oops. So fix it by adding a check and converting unknown
> or invalid error codes to -ESERVERFAULT.
>
> Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
> ---
> :100644 100644 787ccdd... c9a5bf9... M  net/9p/client.c
> :100644 100644 fdebe43... 5251851... M  net/9p/error.c
>  net/9p/client.c |    7 +------
>  net/9p/error.c  |    2 +-
>  2 files changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 787ccdd..c9a5bf9 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -411,14 +411,9 @@ static int p9_check_errors(struct p9_client *c, struct p9_req_t *req)
>                if (c->dotu)
>                        err = -ecode;
>
> -               if (!err) {
> +               if (!err || !IS_ERR_VALUE(err))
>                        err = p9_errstr2errno(ename, strlen(ename));
>
> -                       /* string match failed */
> -                       if (!err)
> -                               err = -ESERVERFAULT;
> -               }
> -
>                P9_DPRINTK(P9_DEBUG_9P, "<<< RERROR (%d) %s\n", -ecode, ename);
>
>                kfree(ename);
> diff --git a/net/9p/error.c b/net/9p/error.c
> index fdebe43..5251851 100644
> --- a/net/9p/error.c
> +++ b/net/9p/error.c
> @@ -239,7 +239,7 @@ int p9_errstr2errno(char *errstr, int len)
>                errstr[len] = 0;
>                printk(KERN_ERR "%s: server reported unknown error %s\n",
>                        __func__, errstr);
> -               errno = 1;
> +               errno = ESERVERFAULT;
>        }
>
>        return -errno;
> --
> 1.6.0.4
>
>
