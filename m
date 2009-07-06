Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbZGFFol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbZGFFol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 01:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZGFFoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 01:44:34 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:52577 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbZGFFoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 01:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Y/IUII69rtv6k+eSQTSQf6BvZ5WywzlSLYEmGZBh7MOXinXbhYfCwqV62LChI9rNe6
         nvYyDRIUfQslJhp6JxGbD49tV1S1Ln4vgwUvcGY8/EunTXENPr7wDR3EbY69jHoiijGe
         OKwkNfAhtfGRnqZ7/hDMGni2hiESsDRQ29fPo=
MIME-Version: 1.0
Date: Mon, 6 Jul 2009 01:44:35 -0400
Message-ID: <3fee128b0907052244n1c5fe000me5ca087918f6fa41@mail.gmail.com>
Subject: [patch] perf_counter : breaking parameter parsing when the command is 
	reached
From: Erdem Aktas <eaktas1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Once the perf parameter parser reaches a non-parameter word, that means
    the command is already found and the rest of the string is the parameter
    of this command so no need to parse more.

    As an example, when we want to run
    perf stat -- ls -al
    it is obvious that the -al is the parameter of the ls command, so we
    should able to run this like
    perf stat ls -al

    Signed-off-by: eaktas <eaktas1@gmail.com>

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 1bf6719..4ad4962 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -284,6 +284,11 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 			if (ctx->flags & PARSE_OPT_STOP_AT_NON_OPTION)
 				break;
 			ctx->out[ctx->cpidx++] = ctx->argv[0];
+			while (--(ctx->argc)) {
+				ctx->argv++;
+				ctx->out[ctx->cpidx++] = ctx->argv[0];
+			}
+			ctx->argc++;
 			continue;
 		}
