Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357Ab0AUOtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab0AUOtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 09:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227Ab0AUOtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 09:49:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab0AUOtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 09:49:11 -0500
Date: Thu, 21 Jan 2010 12:49:02 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf top: losing events?
Message-ID: <20100121144902.GA1244@ghostprotocols.net>
References: <1264052528.26323.13.camel@marge.simson.net> <20100121122224.GA21083@ghostprotocols.net> <1264084112.5933.6.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264084112.5933.6.camel@marge.simson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 21, 2010 at 03:28:32PM +0100, Mike Galbraith escreveu:
> On Thu, 2010-01-21 at 10:22 -0200, Arnaldo Carvalho de Melo wrote:
> 
> > Can you check if this one helps? 
> 
> Made interrupt count correct, but symbols aren't mapped after the task
> forks it seems.  At least, in event__preprocess_sample(), after
> thread__find_addr_location(), al->map is NULL a LOT.

Try this one on top of the previous one:

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8b04988..2227b84 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -975,6 +975,10 @@ static int event__process(event_t *event, struct perf_session *session)
 	case PERF_RECORD_MMAP:
 		event__process_mmap(event, session);
 		break;
+	case PERF_RECORD_FORK:
+	case PERF_RECORD_EXIT:
+		event__process_task(event, session);
+		break;
 	default:
 		break;
 	}
