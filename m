Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbZKCA1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbZKCA1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 19:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbZKCA1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 19:27:13 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:40233 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbZKCA1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 19:27:12 -0500
Message-ID: <4AEF78E4.2020103@linux.vnet.ibm.com>
Date: Mon, 02 Nov 2009 16:27:16 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, paulus@au1.ibm.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf_events: zero time running and enabled, but non-zero count
References: <4AE20102.8010002@linux.vnet.ibm.com> <20091023193246.GA3139@elte.hu> <4AE21655.6040403@linux.vnet.ibm.com> <20091023205711.GB8356@elte.hu> <4AE50B55.4070706@linux.vnet.ibm.com> <20091102212033.GG4880@nowhere>
In-Reply-To: <20091102212033.GG4880@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Sun, Oct 25, 2009 at 07:37:09PM -0700, Corey Ashford wrote:
>>  I'm getting this error on a Power5 box:
>>
>> ../../lib/find_next_bit.c: In function ‘ext2_swabp’:
>> ../../lib/find_next_bit.c:168: warning: passing argument 1 of  
>> ‘__swab64p’ from incompatible pointer type
>> make: *** [util/find_next_bit.o] Error 1
>>
>> I looked at the code and it looks ok to me.  There's a cast from an  
>> "unsigned long *" to a "unsigned long long *", but those types should be  
>> of the same size (in -m64 mode), so I don't know why this is failing.
> 
> 
> Yeah, it's ok because we have the BITS_PER_LONG check. But gcc is not
> aware of that and just consider the cast as breaking the strict aliasing
> rules.
> 
> Can you tell me if the following patch works for you? (only for
> this build error).

Thanks for looking into the build problem, Frederic.  With your patch, I'm still 
seeing the error:

% patch -p1 < ~/patch
patching file tools/perf/Makefile
Hunk #1 succeeded at 845 (offset -1 lines).
% cd tools/perf
~/linux.trees.git/tools/perf
% make
Makefile:472: No libdwarf.h found or old libdwarf.h found, disables dwarf 
support. Please install libdwarf-dev/libdwarf-devel >= 20081231
     CC util/find_next_bit.o
cc1: warnings being treated as errors
../../lib/find_next_bit.c: In function 'ext2_swabp':
../../lib/find_next_bit.c:168: warning: passing argument 1 of '__swab64p' from 
incompatible pointer type
make: *** [util/find_next_bit.o] Error 1
elm3c4.beaverton.ibm.com:corey-13% cat ~/patch
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 800783d..167bc04 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -846,8 +846,9 @@ util/bitmap.o: ../../lib/bitmap.c PERF-CFLAGS
  util/hweight.o: ../../lib/hweight.c PERF-CFLAGS
         $(QUIET_CC)$(CC) -o util/hweight.o -c $(ALL_CFLAGS) 
-DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<

+KFNB_FLAGS = `echo $(ALL_CFLAGS) | sed s/-Wstrict-aliasing=3//`
  util/find_next_bit.o: ../../lib/find_next_bit.c PERF-CFLAGS
-       $(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(ALL_CFLAGS) 
-DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+       $(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(KFNB_FLAGS) 
-DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<

  perf-%$X: %.o $(PERFLIBS)
         $(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) 
$(LIBS)

> 
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 800783d..167bc04 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -846,8 +846,9 @@ util/bitmap.o: ../../lib/bitmap.c PERF-CFLAGS
>  util/hweight.o: ../../lib/hweight.c PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o util/hweight.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
> 
> +KFNB_FLAGS = `echo $(ALL_CFLAGS) | sed s/-Wstrict-aliasing=3//`
>  util/find_next_bit.o: ../../lib/find_next_bit.c PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
> +	$(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(KFNB_FLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
> 
>  perf-%$X: %.o $(PERFLIBS)
>  	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS)
> 
> 

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

