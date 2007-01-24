Return-Path: <linux-kernel-owner+w=401wt.eu-S1750957AbXAXP1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957AbXAXP1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXAXP1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:27:35 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41035 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbXAXP1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:27:34 -0500
Message-ID: <45B77AE4.2010605@drzeus.cx>
Date: Wed, 24 Jan 2007 16:27:32 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Petr Vandrovec <vandrove@vc.cvut.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz>
In-Reply-To: <459E01B2.50309@vc.cvut.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry this took some time, I've been busy with other things.

Petr Vandrovec wrote:
>
> Unfortunately NCP does not run on top of TCP stream, but on top of
> IPX/UDP, and so dropping reply is not sufficient - you must continue
> resending request (so you must buffer it somewhere...) until you get
> result from server - after you receive answer from server, you can
> finally throw away both request & reply, and move on.
>

I don't quite understand why you need to resend. I did the following and
it seems to work fine with UDP:

diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
index e496d8b..5159bae 100644
--- a/fs/ncpfs/sock.c
+++ b/fs/ncpfs/sock.c
@@ -151,6 +153,8 @@ static inline int get_conn_number(struct
ncp_reply_header *rp)
        return rp->conn_low | (rp->conn_high << 8);
 }
 
+static void __ncp_next_request(struct ncp_server *server);
+
 static inline void __ncp_abort_request(struct ncp_server *server,
struct ncp_request_reply *req, int err)
 {
        /* If req is done, we got signal, but we also received answer... */
@@ -163,7 +167,10 @@ static inline void __ncp_abort_request(struct
ncp_server *server, struct ncp_req
                        ncp_finish_request(req, err);
                        break;
                case RQ_INPROGRESS:
-                       __abort_ncp_connection(server, req, err);
+                       printk(KERN_INFO "ncpfs: Killing running
request!\n");
+                       ncp_finish_request(req, err);
+                       __ncp_next_request(server);
+//                     __abort_ncp_connection(server, req, err);
                        break;
        }
 }
@@ -754,7 +761,8 @@ static int ncp_do_request(struct ncp_server *server,
int size,
        if (result < 0) {
                /* There was a problem with I/O, so the connections is
                 * no longer usable. */
-               ncp_invalidate_conn(server);
+               printk(KERN_INFO "ncpfs: Invalidating connection!\n");
+//             ncp_invalidate_conn(server);
        }
        return result;
 }

I'm not particularly proud of the second chunk though. Ideas on how to
handle when we actually get a transmission problem and not just getting
killed by a signal?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

