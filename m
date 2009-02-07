Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZBGLrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZBGLrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 06:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbZBGLrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 06:47:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:46030 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752250AbZBGLrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 06:47:20 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/5JccCKGP5DQcL8gWNIJr1MFVKg6wD755va2IHxr
	uggxgVFngNzCq6
Subject: kerneltop "enhancements"
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1233813650.9044.29.camel@marge.simson.net>
References: <1233813650.9044.29.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 07 Feb 2009 12:47:16 +0100
Message-Id: <1234007236.24521.29.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Dunno if you're interested in any of this...

While tinkering, trying to figure out why I receive more events when
using -C 0 than when profiling all CPUs, I found that it's because of
blocking reads jamming up the loop.  I also noticed that when using
poll, my event count when not using -C N would rise up to the expected
level, but it maxed out at around 25k events/sec for the whole box.
That turned out to be...
 
	if (!event_array[i][counter].revents)
		continue;

I guess I need to look into that a bit more, but without it, using poll
to stop the loop only once we've read all we can get with non-blocking
reads, things improved a bunch.  However, when only one CPU was busy, I
ended up with default_idle screwing things up.  Below is what I did
about all this.

Now, with netperf TCP_RR running on one CPU...
------------------------------------------------------------------------------
 KernelTop:   23686 irqs/sec  kernel:95.8% [NMI, 100000 CPU cycles],  (all, 4 CPUs)
------------------------------------------------------------------------------

             events         RIP          kernel function
  ______     ______   ________________   _______________

            6972.00 - ffffffff803f1c66 : tcp_ack
            6290.00 - ffffffff8047bb7f : __schedule
            4733.00 - ffffffff803ec4df : tcp_sendmsg
            4437.00 - ffffffff803f5f96 : tcp_transmit_skb
            4080.00 - ffffffff8047df48 : _spin_lock_irqsave
            3685.00 - ffffffff8020a6a8 : __switch_to
            3502.00 - ffffffff8047e0ac : _spin_lock_bh
            3477.00 - ffffffff803eb543 : tcp_recvmsg
            3227.00 - ffffffff803fbcbf : tcp_v4_rcv
            3091.00 - ffffffff803f3df5 : tcp_rcv_established
            3052.00 - ffffffff8020be10 : system_call
            2376.00 - ffffffff8047dfd2 : _spin_lock
            2153.00 - ffffffff803c2630 : net_rx_action
            2129.00 - ffffffff803e7526 : __inet_lookup_established
            2071.00 - ffffffff803c3b28 : netif_receive_skb
            2055.00 - ffffffff8023ce9f : local_bh_enable
            2043.00 - ffffffff80211c88 : native_sched_clock
            2010.00 - ffffffff803e069a : ip_rcv
            1910.00 - ffffffff8047e01e : _spin_unlock_irqrestore
..or on all CPUS..

------------------------------------------------------------------------------
 KernelTop:   93783 irqs/sec  kernel:96.0% [NMI, 100000 CPU cycles],
(all, 4 CPUs)
------------------------------------------------------------------------------

             events         RIP          kernel function
  ______     ______   ________________   _______________

           30798.00 - ffffffff803f1c66 : tcp_ack
           26258.00 - ffffffff803ec4df : tcp_sendmsg
           20500.00 - ffffffff8047bb7f : __schedule
           19242.00 - ffffffff803f5f96 : tcp_transmit_skb
           14895.00 - ffffffff803eb543 : tcp_recvmsg
           13926.00 - ffffffff8047e0ac : _spin_lock_bh
           13015.00 - ffffffff803f3df5 : tcp_rcv_established
           12699.00 - ffffffff803e4945 : ip_queue_xmit
           12213.00 - ffffffff8047df48 : _spin_lock_irqsave
           11770.00 - ffffffff803fbcbf : tcp_v4_rcv
           11585.00 - ffffffff8020a6a8 : __switch_to
           11391.00 - ffffffff8020be10 : system_call
            9522.00 - ffffffff803e4fdc : ip_finish_output
            9247.00 - ffffffff803f83a8 : tcp_write_xmit
            8764.00 - ffffffff803c851a : dst_release
            8597.00 - ffffffff8023ce9f : local_bh_enable
            8301.00 - ffffffff8047dfd2 : _spin_lock
            8261.00 - ffffffff803c2630 : net_rx_action
            8224.00 - ffffffff803c3b28 : netif_receive_skb


BTW, how does one convince getopt_long() that an option really really
doesn't require an argument?  no_argument works for the long version,
but it insists that an argument is required for the short version
regardless.

--- kerneltop.c.org	2009-02-05 09:54:23.000000000 +0100
+++ kerneltop.c	2009-02-07 11:53:59.000000000 +0100
@@ -199,6 +199,7 @@ static unsigned long		filter_start;
 static unsigned long		filter_end;
 
 static int			delay_secs			=  2;
+static int			zero;
 static int			dump_symtab;
 
 struct source_line {
@@ -232,7 +233,8 @@ static void display_help(void)
 	" -f CNT --filter=CNT          # min-event-count filter          [default: 100]\n\n"
 	" -x path   --vmlinux=<path>   # the vmlinux binary, for -s use:\n"
 	" -s symbol --symbol=<symbol>  # function to be showed annotated one-shot\n"
-	" -D 1 --dump_symtab=1         # dump symbol table to stderr on startup\n"
+	" -z 1      --zero             # zero counts after display\n"
+	" -D 1      --dump_symtab      # dump symbol table to stderr on startup\n"
 	"\n");
 
 	exit(0);
@@ -257,10 +259,11 @@ static void process_options(int argc, ch
 			{"pid",		required_argument,	NULL, 'p'},
 			{"vmlinux",	required_argument,	NULL, 'x'},
 			{"symbol",	required_argument,	NULL, 's'},
+			{"zero",	no_argument,		NULL, 'z'},
 			{"dump_symtab",	required_argument,	NULL, 'D'},
 			{NULL,		0,			NULL,  0 }
 		};
-		int c = getopt_long(argc, argv, "c:C:d:e:f:g:n:p:s:x:D:",
+		int c = getopt_long(argc, argv, "c:C:d:e:f:g:n:p:s:x:z:D:",
 				    long_options, &option_index);
 		if (c == -1)
 			break;
@@ -284,6 +287,7 @@ static void process_options(int argc, ch
 		case 'n': nmi				=   atoi(optarg); break;
 		case 'p': tid				=   atoi(optarg); break;
 		case 's': sym_filter			= strdup(optarg); break;
+		case 'z': zero				=              1; break;
 		case 'x': vmlinux			= strdup(optarg); break;
 		case 'D': dump_symtab			=   atoi(optarg); break;
 		default: error = 1; break;
@@ -314,6 +318,7 @@ struct sym_entry {
 	unsigned long long	addr;
 	char			*sym;
 	unsigned long		count[MAX_COUNTERS];
+	int			skip;
 	GList			*source;
 };
 
@@ -357,8 +362,6 @@ static long			events;
 static long			userspace_events;
 static const char		CONSOLE_CLEAR[] = "[H[2J";
 
-#define USE_POLL		0
-
 static struct sym_entry		tmp[MAX_SYMS];
 
 static void print_sym_table(void)
@@ -445,7 +448,7 @@ static void print_sym_table(void)
 		 * Add decay to the counts:
 		 */
 		for (count = 0; count < nr_counters; count++)
-			sym_table[i].count[count] = sym_table[i].count[count] * 7 / 8;
+			sym_table[i].count[count] = zero ? 0 : sym_table[i].count[count] * 7 / 8;
 	}
 
 	if (sym_filter_entry)
@@ -489,18 +492,13 @@ static int read_symbol(FILE *in, struct
 
 	sym = str;
 
-	if (!strcmp(sym, "_text")) {
-		min_ip = s->addr;
+	/* Filter out known duplicates and non-text symbols. */
+	if (!strcmp(sym, "_text"))
 		return 1;
-	}
-	if (!min_ip && !strcmp(sym, "_stext")) {
-		min_ip = s->addr;
+	if (!min_ip && !strcmp(sym, "_stext"))
 		return 1;
-	}
 	if (!strcmp(sym, "_etext") || !strcmp(sym, "_sinittext"))
 		return 1;
-
-	/* Filter out known duplicates and non-text symbols. */
 	if (stype != 'T' && stype != 't')
 		return 1;
 	if (!strncmp("init_module", sym, 11) || !strncmp("cleanup_module", sym, 14))
@@ -512,6 +510,13 @@ static int read_symbol(FILE *in, struct
 	assert(s->sym);
 
 	strcpy((char *)s->sym, str);
+	s->skip = 0;
+
+	/* Tag events to be skipped. */
+	if (!strcmp("default_idle", s->sym) || !strcmp("cpu_idle", s->sym))
+		s->skip = 1;
+	if (!strcmp("enter_idle", s->sym) || !strcmp("exit_idle", s->sym))
+		s->skip = 1;
 
 	if (filter_match == 1) {
 		filter_end = s->addr;
@@ -783,18 +788,14 @@ static void record_ip(uint64_t ip, int c
 
 	idx = left_idx;
 
-	sym_table[idx].count[counter]++;
+	if (!sym_table[idx].skip)
+		sym_table[idx].count[counter]++;
+	else events--;
 }
 
-static const int event_threshold = 10000;
-
 static void process_event(uint64_t ip, int counter)
 {
 	events++;
-	if (time(NULL) >= last_refresh + delay_secs) {
-		print_sym_table();
-		events = userspace_events = 0;
-	}
 
 	if (ip < min_ip || ip > max_ip) {
 		userspace_events++;
@@ -813,9 +814,7 @@ int main(int argc, char *argv[])
 	unsigned int cpu;
 	uint64_t ip;
 	ssize_t res;
-#if USE_POLL
 	int ret;
-#endif
 
 	process_options(argc, argv);
 
@@ -840,6 +839,7 @@ int main(int argc, char *argv[])
 			hw_event.nmi		= nmi;
 
 			fd[i][counter] = sys_perf_counter_open(&hw_event, tid, cpu, group_fd);
+			fcntl(fd[i][counter], F_SETFL, O_NONBLOCK);
 			if (fd[i][counter] < 0) {
 				printf("kerneltop error: syscall returned with %d (%s)\n",
 					fd[i][counter], strerror(-fd[i][counter]));
@@ -868,23 +868,27 @@ int main(int argc, char *argv[])
 	last_refresh = time(NULL);
 
 	while (1) {
-#if USE_POLL
-		ret = poll(event_array, nr_cpus, 1000);
-#endif
+		int hits = events;
 
 		for (i = 0; i < nr_cpus; i++) {
 			for (counter = 0; counter < nr_counters; counter++) {
-#if USE_POLL
-				if (!event_array[i][counter].revents)
-					continue;
-#endif
-
 				res = read(fd[i][counter], (char *) &ip, sizeof(ip));
-				assert(res == sizeof(ip));
+				if (res > 0) {
+					assert(res == sizeof(ip));
 
-				process_event(ip, counter);
+					process_event(ip, counter);
+				}
 			}
 		}
+
+		if (time(NULL) >= last_refresh + delay_secs) {
+			print_sym_table();
+			events = userspace_events = 0;
+		}
+
+		if (hits == events)
+			ret = poll(event_array, nr_cpus, 1000);
+		hits = events;
 	}
 
 	return 0;


