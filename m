Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZKBVUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZKBVUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZKBVUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:20:37 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59213 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbZKBVUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:20:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=TjiWkzUVTNSg1i8kQ3UuxxsVYjjguwqFlnzJeSHmHZjf0+dojmJrF7495nw0VUkZPl
         h2oTkWdHFy5J8jj4RN3Id0KiYaoEXObjhZ68hzjVVekUWQiuIZ2q1DZoUelrcDdETfXz
         wO6my7qZqE82piirixcqQLxBkLSEiqjOF30iw=
Date: Mon, 2 Nov 2009 22:20:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, paulus@au1.ibm.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf_events: zero time running and enabled, but non-zero count
Message-ID: <20091102212033.GG4880@nowhere>
References: <4AE20102.8010002@linux.vnet.ibm.com> <20091023193246.GA3139@elte.hu> <4AE21655.6040403@linux.vnet.ibm.com> <20091023205711.GB8356@elte.hu> <4AE50B55.4070706@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AE50B55.4070706@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 25, 2009 at 07:37:09PM -0700, Corey Ashford wrote:
>  I'm getting this error on a Power5 box:
>
> ../../lib/find_next_bit.c: In function ‘ext2_swabp’:
> ../../lib/find_next_bit.c:168: warning: passing argument 1 of  
> ‘__swab64p’ from incompatible pointer type
> make: *** [util/find_next_bit.o] Error 1
>
> I looked at the code and it looks ok to me.  There's a cast from an  
> "unsigned long *" to a "unsigned long long *", but those types should be  
> of the same size (in -m64 mode), so I don't know why this is failing.


Yeah, it's ok because we have the BITS_PER_LONG check. But gcc is not
aware of that and just consider the cast as breaking the strict aliasing
rules.

Can you tell me if the following patch works for you? (only for
this build error).

Thanks.


diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 800783d..167bc04 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -846,8 +846,9 @@ util/bitmap.o: ../../lib/bitmap.c PERF-CFLAGS
 util/hweight.o: ../../lib/hweight.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/hweight.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+KFNB_FLAGS = `echo $(ALL_CFLAGS) | sed s/-Wstrict-aliasing=3//`
 util/find_next_bit.o: ../../lib/find_next_bit.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+	$(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(KFNB_FLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
 perf-%$X: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS)


