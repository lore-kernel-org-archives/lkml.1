Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZFYM4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZFYM4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbZFYMzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:55:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:48648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbZFYMzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:55:54 -0400
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090625093346.GD23547@elte.hu>
References: <1245760130.3776.6.camel@localhost.localdomain>
	 <20090623195656.GC8777@elte.hu>
	 <1245876060.3038.7.camel@localhost.localdomain>
	 <20090625093346.GD23547@elte.hu>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 18:25:22 +0530
Message-Id: <1245934522.5308.39.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 11:33 +0200, Ingo Molnar wrote:

> Firstly, please run your patches through checkpatch - it will report 
> a real problem in your patch.
> 
> Secondly, this special-casing of the BPU isnt very clean in this 
> form. The BPU isnt 'special' because it deals with instructions - 
> it's special because it's for all practical purposes read-only.
> 
> So we should extend our table with a read-only flag, and the BPU and 
> the iTLB should be listed as read-only. (iTLB-store-miss is another 
> thing that makes no sense) For those we should skip the 'store' 
> bits.
> 
> That way the generic code does not have this special-case wart 
> dependent on PERF_COUNT_HW_CACHE_BPU.
> 

I am sorry BPU still needs special handling ;-)

[PATCH] perf_counter tools: shorten names for events

Added new alias for events.

special handling for BPU for :
 'branch loads'       -> 'branches'
 'branch load-misses' -> 'branch-misses'

On AMD box:
$ ./perf stat -e l1d -e l1d-misses -e l1d-write -e l1d-prefetch -e l1d-prefetch-miss -e l1i -e l1i-misses -e l1i-prefetch -e l2 -e l2-misses -e l2-write -e dtlb -e dtlb-misses -e itlb -e itlb-misses -e bpu -e bpu-misses -- ls -lR /usr/include/ > /dev/null

Before :

 Performance counter stats for 'ls -lR /usr/include/':

      248064467  L1-data-Cache-Load-Referencees  (scaled from 23.27%)
        1001433  L1-data-Cache-Load-Misses  (scaled from 23.34%)
         153691  L1-data-Cache-Store-Referencees  (scaled from 23.34%)
         423248  L1-data-Cache-Prefetch-Referencees  (scaled from 23.33%)
         302138  L1-data-Cache-Prefetch-Misses  (scaled from 23.25%)
      251217546  L1-instruction-Cache-Load-Referencees  (scaled from 23.25%)
        5757005  L1-instruction-Cache-Load-Misses  (scaled from 23.23%)
          93435  L1-instruction-Cache-Prefetch-Referencees  (scaled from 23.24%)
        6496073  L2-Cache-Load-Referencees  (scaled from 23.32%)
         609485  L2-Cache-Load-Misses  (scaled from 23.45%)
        6876991  L2-Cache-Store-Referencees  (scaled from 23.71%)
      248922840  Data-TLB-Cache-Load-Referencees  (scaled from 23.94%)
        5828386  Data-TLB-Cache-Load-Misses  (scaled from 24.17%)
      257613506  Instruction-TLB-Cache-Load-Referencees  (scaled from 24.20%)
           6833  Instruction-TLB-Cache-Load-Misses  (scaled from 23.88%)
      109043606  Branch-Cache-Load-Referencees  (scaled from 23.64%)
        5552296  Branch-Cache-Load-Misses  (scaled from 23.42%)

    0.413702461  seconds time elapsed.

After :

 Peformance counter stats for 'ls -lR /usr/include/':

      266590464  L1d-loads             (scaled from 23.03%)
        1222273  L1d-load-misses       (scaled from 23.58%)
         146204  L1d-stores            (scaled from 23.83%)
         406344  L1d-prefetches        (scaled from 24.09%)
         283748  L1d-prefetch-misses   (scaled from 24.10%)
      249650965  L1i-loads             (scaled from 23.80%)
        3353961  L1i-load-misses       (scaled from 23.82%)
         104599  L1i-prefetches        (scaled from 23.68%)
        4836405  LLC-loads             (scaled from 23.67%)
         498214  LLC-load-misses       (scaled from 23.66%)
        4953994  LLC-stores            (scaled from 23.64%)
      243354097  dTLB-loads            (scaled from 23.77%)
        6468584  dTLB-load-misses      (scaled from 23.74%)
      249719549  iTLB-loads            (scaled from 23.25%)
           5060  iTLB-load-misses      (scaled from 23.00%)
      112343016  branches              (scaled from 22.76%)
        5528876  branch-misses         (scaled from 22.54%)

    0.427154051  seconds time elapsed.

Reported-by : Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   56 +++++++++++++++++++++++++++------------
 1 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 7939a21..993cee4 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -71,23 +71,23 @@ static char *sw_event_names[] = {
 #define MAX_ALIASES 8
 
 static char *hw_cache[][MAX_ALIASES] = {
-	{ "L1-data",		"l1-d",		"l1d"			},
-	{ "L1-instruction",	"l1-i",		"l1i"			},
-	{ "L2",			"l2"					},
-	{ "Data-TLB",		"dtlb",		"d-tlb"			},
-	{ "Instruction-TLB",	"itlb",		"i-tlb"			},
-	{ "Branch",		"bpu" ,		"btb",		"bpc"	},
+ { "L1d",	"l1-d",		"L1-data",				},
+ { "L1i",	"l1-i",		"L1-instruction",			},
+ { "LLC",	"L2"							},
+ { "dTLB",	"d-tlb",	"Data-TLB",				},
+ { "iTLB",	"i-tlb",	"Instruction-TLB",			},
+ { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
 };
 
 static char *hw_cache_op[][MAX_ALIASES] = {
-	{ "Load",		"read"					},
-	{ "Store",		"write"					},
-	{ "Prefetch",		"speculative-read", "speculative-load"	},
+ { "load",	"loads",	"read",					},
+ { "store",	"stores",	"write",				},
+ { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
 };
 
 static char *hw_cache_result[][MAX_ALIASES] = {
-	{ "Reference",		"ops",		"access"		},
-	{ "Miss"							},
+ { "refs",	"Reference",	"ops",		"access",		},
+ { "misses",	"miss",							},
 };
 
 #define C(x)		PERF_COUNT_HW_CACHE_##x
@@ -118,6 +118,33 @@ static int is_cache_op_valid(u8 cache_type, u8 cache_op)
 		return 0;	/* invalid */
 }
 
+static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
+{
+	static char name[50];
+
+	/*
+	 * special handling for BPU for :
+	 * 'branch loads'	-> 'branches'
+	 * 'branch load-misses'	-> 'branch-misses'
+	 */
+	if (cache_type == PERF_COUNT_HW_CACHE_BPU) {
+		if (cache_result)
+			sprintf(name, "%s-%s", hw_cache[cache_type][0],
+				hw_cache_result[cache_result][0]);
+		else
+			sprintf(name, "%s", hw_cache[cache_type][1]);
+
+	} else if (cache_result)
+		sprintf(name, "%s-%s-%s", hw_cache[cache_type][0],
+			hw_cache_op[cache_op][0],
+			hw_cache_result[cache_result][0]);
+		else
+			sprintf(name, "%s-%s", hw_cache[cache_type][0],
+				hw_cache_op[cache_op][1]);
+
+	return name;
+}
+
 char *event_name(int counter)
 {
 	u64 config = attrs[counter].config;
@@ -137,7 +164,6 @@ char *event_name(int counter)
 
 	case PERF_TYPE_HW_CACHE: {
 		u8 cache_type, cache_op, cache_result;
-		static char name[100];
 
 		cache_type   = (config >>  0) & 0xff;
 		if (cache_type > PERF_COUNT_HW_CACHE_MAX)
@@ -153,12 +179,8 @@ char *event_name(int counter)
 
 		if (!is_cache_op_valid(cache_type, cache_op))
 			return "invalid-cache";
-		sprintf(name, "%s-Cache-%s-%ses",
-			hw_cache[cache_type][0],
-			hw_cache_op[cache_op][0],
-			hw_cache_result[cache_result][0]);
 
-		return name;
+		return event_cache_name(cache_type, cache_op, cache_result);
 	}
 
 	case PERF_TYPE_SOFTWARE:
-- 
1.6.0.6



