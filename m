Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZFVLRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZFVLRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZFVLRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:17:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:52115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbZFVLRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:17:05 -0400
Subject: [PATCH 2/2 -tip] perf_counter: parse-events.c introduce alias
 member in event_symbol
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245669194.17153.6.camel@localhost.localdomain>
References: <1245669194.17153.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 16:44:28 +0530
Message-Id: <1245669268.17153.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By introducing alias member in event_symbol :

1. duplicate lines are removed, like:
   cpu-cycles and cycles
   branch-instructions and branches
   context-switches and cs
   cpu-migrations and migrations

2. We can also add alias for another events.

Now ./perf list looks like :

List of pre-defined events (to be used in -e):

  cpu-cycles OR cycles                     [Hardware event]
  instructions                             [Hardware event]
  cache-references                         [Hardware event]
  cache-misses                             [Hardware event]
  branch-instructions OR branches          [Hardware event]
  branch-misses                            [Hardware event]
  bus-cycles                               [Hardware event]

  cpu-clock                                [Software event]
  task-clock                               [Software event]
  page-faults                              [Software event]
  faults                                   [Software event]
  minor-faults                             [Software event]
  major-faults                             [Software event]
  context-switches OR cs                   [Software event]
  cpu-migrations OR migrations             [Software event]

  rNNN                                     [raw hardware event descriptor]

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/util/parse-events.c |   63 ++++++++++++++++++++++++----------------
 1 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 12abab3..f569548 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -16,32 +16,29 @@ struct event_symbol {
 	u8	type;
 	u64	config;
 	char	*symbol;
+	char	*alias;
 };
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
 
 static struct event_symbol event_symbols[] = {
-  { CHW(CPU_CYCLES),		"cpu-cycles",		},
-  { CHW(CPU_CYCLES),		"cycles",		},
-  { CHW(INSTRUCTIONS),		"instructions",		},
-  { CHW(CACHE_REFERENCES),	"cache-references",	},
-  { CHW(CACHE_MISSES),		"cache-misses",		},
-  { CHW(BRANCH_INSTRUCTIONS),	"branch-instructions",	},
-  { CHW(BRANCH_INSTRUCTIONS),	"branches",		},
-  { CHW(BRANCH_MISSES),		"branch-misses",	},
-  { CHW(BUS_CYCLES),		"bus-cycles",		},
-
-  { CSW(CPU_CLOCK),		"cpu-clock",		},
-  { CSW(TASK_CLOCK),		"task-clock",		},
-  { CSW(PAGE_FAULTS),		"page-faults",		},
-  { CSW(PAGE_FAULTS),		"faults",		},
-  { CSW(PAGE_FAULTS_MIN),	"minor-faults",		},
-  { CSW(PAGE_FAULTS_MAJ),	"major-faults",		},
-  { CSW(CONTEXT_SWITCHES),	"context-switches",	},
-  { CSW(CONTEXT_SWITCHES),	"cs",			},
-  { CSW(CPU_MIGRATIONS),	"cpu-migrations",	},
-  { CSW(CPU_MIGRATIONS),	"migrations",		},
+  { CHW(CPU_CYCLES),		"cpu-cycles",		"cycles"	},
+  { CHW(INSTRUCTIONS),		"instructions",		""		},
+  { CHW(CACHE_REFERENCES),	"cache-references",	""		},
+  { CHW(CACHE_MISSES),		"cache-misses",		""		},
+  { CHW(BRANCH_INSTRUCTIONS),	"branch-instructions",	"branches"	},
+  { CHW(BRANCH_MISSES),		"branch-misses",	""		},
+  { CHW(BUS_CYCLES),		"bus-cycles",		""		},
+
+  { CSW(CPU_CLOCK),		"cpu-clock",		""		},
+  { CSW(TASK_CLOCK),		"task-clock",		""		},
+  { CSW(PAGE_FAULTS),		"page-faults",		""		},
+  { CSW(PAGE_FAULTS),		"faults",		""		},
+  { CSW(PAGE_FAULTS_MIN),	"minor-faults",		""		},
+  { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
+  { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
+  { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
 };
 
 #define __PERF_COUNTER_FIELD(config, name) \
@@ -196,6 +193,19 @@ static int parse_generic_hw_symbols(const char *str, struct perf_counter_attr *a
 	return 0;
 }
 
+static int check_events(const char *str, unsigned int i)
+{
+	if (!strncmp(str, event_symbols[i].symbol,
+		     strlen(event_symbols[i].symbol)))
+		return 1;
+
+	if (strlen(event_symbols[i].alias))
+		if (!strncmp(str, event_symbols[i].alias,
+		      strlen(event_symbols[i].alias)))
+			return 1;
+	return 0;
+}
+
 /*
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
@@ -235,9 +245,7 @@ static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		if (!strncmp(str, event_symbols[i].symbol,
-			     strlen(event_symbols[i].symbol))) {
-
+		if (check_events(str, i)) {
 			attr->type = event_symbols[i].type;
 			attr->config = event_symbols[i].config;
 
@@ -289,6 +297,7 @@ void print_events(void)
 {
 	struct event_symbol *syms = event_symbols;
 	unsigned int i, type, prev_type = -1;
+	char name[40];
 
 	fprintf(stderr, "\n");
 	fprintf(stderr, "List of pre-defined events (to be used in -e):\n");
@@ -301,14 +310,18 @@ void print_events(void)
 		if (type != prev_type)
 			fprintf(stderr, "\n");
 
-		fprintf(stderr, "  %-30s [%s]\n", syms->symbol,
+		if (strlen(syms->alias))
+			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
+		else
+			strcpy(name, syms->symbol);
+		fprintf(stderr, "  %-40s [%s]\n", name,
 			event_type_descriptors[type]);
 
 		prev_type = type;
 	}
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, "  %-30s [raw hardware event descriptor]\n",
+	fprintf(stderr, "  %-40s [raw hardware event descriptor]\n",
 		"rNNN");
 	fprintf(stderr, "\n");
 
-- 
1.6.0.6



