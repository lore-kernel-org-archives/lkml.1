Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYGUSoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYGUSoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYGUSnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:43:52 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:42816 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYGUSnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:43:51 -0400
Message-ID: <4884D8DC.1000004@hp.com>
Date: Mon, 21 Jul 2008 14:43:40 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH application] Allow one to filter on specific trace actions
Content-Type: multipart/mixed;
 boundary="------------050808010508080905010104"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050808010508080905010104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------050808010508080905010104
Content-Type: text/x-diff;
 name="0002-Allow-one-to-filter-on-specific-trace-actions.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-Allow-one-to-filter-on-specific-trace-actions.patch"

>From 8dbad2d1af70f3dce95e3d38a5f8cb582a02a69e Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Mon, 21 Jul 2008 14:41:54 -0400
Subject: [PATCH] Allow one to filter on specific trace actions

Added in new '-m' option to blktrace: Can now specify filter at a specific
trace action.

Also: fixed up a missing NOTIFY in the mas_maps table. Updated doc -
still need to do man page.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 act_mask.c       |   43 +++++++++++++++++++++++---
 blktrace.c       |   30 +++++++++++++++---
 blktrace.h       |    1 +
 blktrace_api.h   |    1 +
 doc/blktrace.tex |   90 +++++++++++++++++++++++++++++++++++------------------
 5 files changed, 124 insertions(+), 41 deletions(-)

diff --git a/act_mask.c b/act_mask.c
index 40a4050..87faa62 100644
--- a/act_mask.c
+++ b/act_mask.c
@@ -1,7 +1,9 @@
 #include <strings.h>
 #include "blktrace.h"
 
-#define DECLARE_MASK_MAP(mask)          { BLK_TC_##mask, #mask, "BLK_TC_"#mask }
+#define DECLARE_MASK_MAP(mask)	{ BLK_TC_##mask, #mask, "BLK_TC_"#mask }
+#define DECLARE_TRACE_MAP(mask)	{ __BLK_TA_##mask, #mask, "__BLK_TA_"#mask }
+
 #define COMPARE_MASK_MAP(mmp, str)                                      \
         (!strcasecmp((mmp)->short_form, (str)) ||                      \
          !strcasecmp((mmp)->long_form, (str)))
@@ -23,22 +25,53 @@ static struct mask_map mask_maps[] = {
 	DECLARE_MASK_MAP(COMPLETE),
 	DECLARE_MASK_MAP(FS),
 	DECLARE_MASK_MAP(PC),
+	DECLARE_MASK_MAP(NOTIFY),
 	DECLARE_MASK_MAP(AHEAD),
 	DECLARE_MASK_MAP(META),
 };
 
-int find_mask_map(char *string)
+static struct mask_map trace_maps[] = {
+	DECLARE_TRACE_MAP(QUEUE),
+	DECLARE_TRACE_MAP(BACKMERGE),
+	DECLARE_TRACE_MAP(FRONTMERGE),
+	DECLARE_TRACE_MAP(GETRQ),
+	DECLARE_TRACE_MAP(SLEEPRQ),
+	DECLARE_TRACE_MAP(REQUEUE),
+	DECLARE_TRACE_MAP(ISSUE),
+	DECLARE_TRACE_MAP(COMPLETE),
+	DECLARE_TRACE_MAP(PLUG),
+	DECLARE_TRACE_MAP(UNPLUG_IO),
+	DECLARE_TRACE_MAP(UNPLUG_TIMER),
+	DECLARE_TRACE_MAP(INSERT),
+	DECLARE_TRACE_MAP(SPLIT),
+	DECLARE_TRACE_MAP(BOUNCE),
+	DECLARE_TRACE_MAP(REMAP),
+};
+
+#define MAP_LEN(map) (sizeof(map) / sizeof((map)[0]))
+
+int find_mask(char *string, struct mask_map *maps, unsigned int map_len)
 {
 	unsigned int i;
 
-	for (i = 0; i < sizeof(mask_maps)/sizeof(mask_maps[0]); i++)
-		if (COMPARE_MASK_MAP(&mask_maps[i], string))
-			return mask_maps[i].mask;
+	for (i = 0; i < map_len; i++)
+		if (COMPARE_MASK_MAP(&maps[i], string))
+			return maps[i].mask;
 
 	return -1;
 }
 
+int find_mask_map(char *string)
+{
+	return find_mask(string, mask_maps, MAP_LEN(mask_maps));
+}
+
 int valid_act_opt(int x)
 {
 	return (1 <= x) && (x < (1 << BLK_TC_SHIFT));
 }
+
+int find_trace_map(char *string)
+{
+	return find_mask(string, trace_maps, MAP_LEN(trace_maps));
+}
diff --git a/blktrace.c b/blktrace.c
index 8892a33..f9131fe 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -60,7 +60,7 @@ static char blktrace_version[] = "0.99.3";
 
 #define DEBUGFS_TYPE	0x64626720
 
-#define S_OPTS	"d:a:A:r:o:kw:Vb:n:D:lh:p:sI:"
+#define S_OPTS	"d:a:A:r:o:kw:Vb:n:D:lh:p:sI:m:"
 static struct option l_opts[] = {
 	{
 		.name = "dev",
@@ -247,6 +247,7 @@ static char *debugfs_path;
 static char *output_name;
 static char *output_dir;
 static int cat_mask = ~0U;
+static u32 trace_mask = ~0U;
 static int kill_running_trace;
 static unsigned long buf_size = BUF_SIZE;
 static unsigned long buf_nr = BUF_NR;
@@ -398,6 +399,7 @@ static int start_trace(struct device_information *dip)
 	buts.buf_size = dip->buf_size;
 	buts.buf_nr = dip->buf_nr;
 	buts.cat_mask = cat_mask;
+	buts.trace_mask = trace_mask;
 
 	if (ioctl(dip->fd, BLKTRACESETUP, &buts) < 0) {
 		perror("BLKTRACESETUP");
@@ -1756,7 +1758,8 @@ static int net_setup_client(void)
 
 static char usage_str[] = \
 	"-d <dev> [ -r debugfs path ] [ -o <output> ] [-k ] [ -w time ]\n" \
-	"[ -a action ] [ -A action mask ] [ -I  <devs file> ] [ -v ]\n\n" \
+	"[ -a action ] [ -A action mask ] [ -I  <devs file> ]\n" \
+	"[ -m trace ] [ -M trace mask ][ -v ]\n\n" \
 	"\t-d Use specified device. May also be given last after options\n" \
 	"\t-r Path to mounted debugfs, defaults to /sys/kernel/debug\n" \
 	"\t-o File(s) to send output to\n" \
@@ -1772,6 +1775,8 @@ static char usage_str[] = \
 	"\t-p Network port to use (default 8462)\n" \
 	"\t-s Make the network client NOT use sendfile() to transfer data\n" \
 	"\t-I Add devices found in <devs file>\n" \
+	"\t-m Only capture specified traces. See documentation\n" \
+	"\t-M Give traces mask as a single value. See documentation\n" \
 	"\t-V Print program version info\n\n";
 
 static void show_usage(char *program)
@@ -1786,6 +1791,7 @@ int main(int argc, char *argv[])
 	int i, c;
 	int stop_watch = 0;
 	int cat_mask_tmp = 0;
+	int trace_mask_tmp = 0;
 
 	while ((c = getopt_long(argc, argv, S_OPTS, l_opts, NULL)) >= 0) {
 		switch (c) {
@@ -1800,7 +1806,7 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'A':
-			if ((sscanf(optarg, "%x", &i) != 1) || 
+			if ((sscanf(optarg, "%x", &i) != 1) ||
 							!valid_act_opt(i)) {
 				fprintf(stderr,
 					"Invalid set action mask %s/0x%x\n",
@@ -1810,6 +1816,17 @@ int main(int argc, char *argv[])
 			cat_mask_tmp = i;
 			break;
 
+		case 'm':
+			i = find_trace_map(optarg);
+			if (i < 0) {
+				fprintf(stderr,
+					"Invalid trace action mask %s\n",
+					optarg);
+				return 1;
+			}
+			trace_mask_tmp |= (1 << i);
+			break;
+
 		case 'd':
 			if (resize_devices(optarg) != 0)
 				return 1;
@@ -1820,8 +1837,8 @@ int main(int argc, char *argv[])
 			FILE *ifp = fopen(optarg, "r");
 
 			if (!ifp) {
-				fprintf(stderr, 
-				        "Invalid file for devices %s\n", 
+				fprintf(stderr,
+				        "Invalid file for devices %s\n",
 					optarg);
 				return 1;
 			}
@@ -1920,6 +1937,9 @@ int main(int argc, char *argv[])
 	if (cat_mask_tmp != 0)
 		cat_mask = cat_mask_tmp;
 
+	if (trace_mask_tmp != 0)
+		trace_mask = trace_mask_tmp;
+
 	if (!debugfs_path)
 		debugfs_path = default_debugfs_path;
 
diff --git a/blktrace.h b/blktrace.h
index 816ce61..b26686d 100644
--- a/blktrace.h
+++ b/blktrace.h
@@ -140,6 +140,7 @@ extern void process_fmt(char *, struct per_cpu_info *, struct blk_io_trace *,
 			unsigned long long, int, unsigned char *);
 extern int valid_act_opt(int);
 extern int find_mask_map(char *);
+extern int find_trace_map(char *);
 extern char *find_process_name(pid_t);
 
 #endif
diff --git a/blktrace_api.h b/blktrace_api.h
index 2b76d76..8490fdc 100644
--- a/blktrace_api.h
+++ b/blktrace_api.h
@@ -115,6 +115,7 @@ struct blk_io_trace_remap {
 struct blk_user_trace_setup {
 	char name[32];			/* output */
 	__u16 cat_mask;			/* input */
+	__u32 trace_mask;			/* input */
 	__u32 buf_size;			/* input */
 	__u32 buf_nr;			/* input */
 	__u64 start_lba;
diff --git a/doc/blktrace.tex b/doc/blktrace.tex
index 1b79c73..bac1495 100644
--- a/doc/blktrace.tex
+++ b/doc/blktrace.tex
@@ -21,7 +21,7 @@
 \title{blktrace User Guide}
 \author{blktrace: Jens Axboe (jens.axboe@oracle.com)\\
         User Guide: Alan D. Brunelle (Alan.Brunelle@hp.com)}
-\date{27 May 2008}
+\date{21 July 2008}
 
 \begin{document}
 \maketitle
@@ -82,7 +82,7 @@ As an example, bt/kernel contains blk-trace-2.6.14-rc1-git-G2, download
 linux-2.6.13.tar.bz2 and patch-2.6.14-rc1.bz2
 
 \begin{verbatim}
-% tar xjf linux-2.6.13.tar.bz2 
+% tar xjf linux-2.6.13.tar.bz2
 % mv linux-2.6.13 linux-2.6.14-rc1
 % cd linux-2.6.14-rc1
 % bunzip2 -c ../patch-2.6.14-rc1.bz2 | patch -p1
@@ -102,7 +102,7 @@ system -- again, outside the scope of this document -- and then enable
 and navigate through \emph{Device Drivers} and \emph{Block devices}
 and then down to \emph{Support for tracing block io actions} and hit Y.
 
-Install the new kernel (and modules\ldots) and reboot. 
+Install the new kernel (and modules\ldots) and reboot.
 
 \subsection{\label{sec:mount}Mounting the debugfs file system}
 
@@ -220,14 +220,14 @@ device. An example of that would be \emph{cdrecord} burning.
 \subsection{\label{sec:blktrace-post}blktrace -- post-processing}
 
 Another way to run blktrace is to have blktrace save data away for later
-formatting by blkparse. This would be useful if you want to get 
+formatting by blkparse. This would be useful if you want to get
 measurements while running specific loads.
 
-To do this, one would specify the device (or devices) to be watched. Then 
+To do this, one would specify the device (or devices) to be watched. Then
 go run you test cases. Stop the trace, and at your leisure utilize
 blkparse to see the results.
 
-In this example, devices /dev/sdaa, /dev/sdc and /dev/sdo are used in an 
+In this example, devices /dev/sdaa, /dev/sdc and /dev/sdo are used in an
 LVM volume called adb3/vol.
 
 \begin{verbatim}
@@ -247,11 +247,11 @@ Maximum filesystem blocks=4294967296
 1025 block groups
 32768 blocks per group, 32768 fragments per group
 16384 inodes per group
-Superblock backups stored on blocks: 
-        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
+Superblock backups stored on blocks:
+        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
 	4096000, 7962624, 11239424, 20480000, 23887872
 
-Writing inode tables: done                            
+Writing inode tables: done
 Creating journal (8192 blocks): done
 Writing superblocks and filesystem accounting information: done
 
@@ -343,7 +343,7 @@ of the more arcane command line options:
   a file created in the mounted directory for the debugfs, which defaults
   to \emph{/sys/kernel/debug} -- this can be overridden with the \emph{-r}
   command line argument.
-  
+
   \item blktrace defaults to collecting \emph{all} events that can be
   traced. To limit the events being captured, you can specify one or
   more filter masks via the \emph{-a} option.
@@ -368,7 +368,7 @@ of the more arcane command line options:
   \item blktrace may also be run concurrently with blkparse to produce
   \emph{live} output -- to do this specify \emph{-o -} for blktrace.
 
-  \item The default behaviour for blktrace is to run forever until explicitly killed by the user (via a control-C, or \emph{kill} utility invocation). There are two ways to modify this: 
+  \item The default behaviour for blktrace is to run forever until explicitly killed by the user (via a control-C, or \emph{kill} utility invocation). There are two ways to modify this:
 
   \begin{enumerate}
     \item You may utilize the blktrace utility itself to \emph{kill}
@@ -395,6 +395,7 @@ Short              & Long                       & Description \\ \hline\hline
 -w \emph{seconds}  & --stopwatch=\emph{seconds} & Sets run time to the number of seconds specified \\ \hline
 -I \emph{devs file}& --input-devs=\emph{devs file}& Adds devices found in \emph{devs file} to list of devices to trace. \\
                    &                              & (One device per line.) \\ \hline
+-m \emph{name}     & --act-mask=\emph{name}     & Add \emph{name} to current trace filter (see below for masks) \\ \hline
 \end{tabular}
 
 \subsubsection{\label{sec:filter-mask}Filter Masks}
@@ -402,17 +403,44 @@ The following category masks may be passed with the \emph{-a} command
 line option, multiple filters may be combined via multiple \emph{-a}
 command line options.\smallskip
 
+\begin{tabular}{|l|l|l|}\hline
+\textbf{Name}	& \textbf{Description}		& \textbf{Hex}	\\ \hline\hline
+ahead		& \emph{Read ahead} events	& 0x0800	\\ \hline
+barrier		& \emph{barrier} attribute	& 0x0004	\\ \hline
+complete	& \emph{completed} by driver	& 0x0080	\\ \hline
+fs		& \emph{FS} requests		& 0x0100	\\ \hline
+issue		& \emph{issued} to driver	& 0x0040	\\ \hline
+meta		& \emph{Metadata} events 	& 0x1000	\\ \hline
+notify		& \emph{Notification} events	& 0x0400	\\ \hline
+pc		& \emph{packet command} events	& 0x0200	\\ \hline
+queue		& \emph{queue} operations	& 0x0010	\\ \hline
+read		& \emph{read} events		& 0x0001	\\ \hline
+requeue		& \emph{requeue} operations	& 0x0020	\\ \hline
+sync		& \emph{synchronous} attribute	& 0x0008	\\ \hline
+write		& \emph{write} events		& 0x0002	\\ \hline
+\end{tabular}
+
+The following trace masks may be pased with the \emph{-m} command line
+option, multiple filters may be combined via multiple \emph{-m} command
+line options.\smallskip
+
 \begin{tabular}{|l|l|}\hline
-barrier & \emph{barrier} attribute \\ \hline
-complete & \emph{completed} by driver \\ \hline
-fs & \emph{FS} requests \\ \hline
-issue & \emph{issued} to driver \\ \hline
-pc & \emph{packet command} events \\ \hline
-queue & \emph{queue} operations \\ \hline
-read & \emph{read} traces \\ \hline
-requeue & \emph{requeue} operations \\ \hline
-sync & \emph{synchronous} attribute \\ \hline
-write & \emph{write} traces \\ \hline
+\textbf{Name}	& \textbf{Description}		\\ \hline\hline
+queue		& \emph{Queue} traces		\\ \hline
+backmerge	& \emph{Back merge} traces	\\ \hline
+frontmerge	& \emph{Merge (front)} traces	\\ \hline
+getrq		& \emph{Get request} traces	\\ \hline
+sleeprq		& \emph{Sleep for req} traces	\\ \hline
+requeue		& \emph{Requeue req} traces	\\ \hline
+issue		& \emph{Issues} traces		\\ \hline
+complete	& \emph{Req completion} traces	\\ \hline
+plug		& \emph{Req queue plug} traces	\\ \hline
+unplug\_io	& \emph{Unplug req Q} traces	\\ \hline
+unplug\_timer	& \emph{Unplug req Q timeout}	\\ \hline
+insert		& \emph{Insertion} traces	\\ \hline
+split		& \emph{Split req} traces	\\ \hline
+bounce		& \emph{Req bounce} traces	\\ \hline
+remap		& \emph{Req remap} traces	\\ \hline
 \end{tabular}
 
 \subsubsection{\label{sec:request-types}Request types}
@@ -439,7 +467,7 @@ will help in understanding the command line options presented below.
   \item By default, blkparse expects to run in a post-processing mode
   -- one where the trace events have been saved by a previous run
   of blktrace, and blkparse is combining event streams and dumping
-  formatted data. 
+  formatted data.
 
   blkparse \emph{may} be run in a \emph{live} manner concurrently with
   blktrace by specifying \emph{-i -} to blkparse, and combining it with
@@ -476,7 +504,7 @@ Short              & Long                       & Description \\ \hline\hline
 		   &                            & (reading data from standard in). \\ \hline
 
 -F \emph{typ,fmt}  & --format=\emph{typ,fmt}    & Sets output format \\
--f \emph{fmt}      & --format-spec=\emph{fmt}   & (See section~\ref{sec:blkparse-format} for details.) \\ 
+-f \emph{fmt}      & --format-spec=\emph{fmt}   & (See section~\ref{sec:blkparse-format} for details.) \\
                    &                            & \\
 		   &                            & The -f form specifies a format for all events \\
                    &                            & \\
@@ -500,7 +528,7 @@ Short              & Long                       & Description \\ \hline\hline
 
 -t                 & --track-ios                & Display time deltas per IO \\ \hline
 
--w \emph{span}     & --stopwatch=\emph{span}    & Display traces for the \emph{span} specified -- where span can be: \\ 
+-w \emph{span}     & --stopwatch=\emph{span}    & Display traces for the \emph{span} specified -- where span can be: \\
                    &                            & \emph{end-time} -- Display traces from time 0 through \emph{end-time} (in ns) \\
 		   &                            & or \\
 		   &                            & \emph{start:end-time} -- Display traces from time \emph{start} \\
@@ -675,7 +703,7 @@ Seeing this in action:
   8,0    3        1     0.000000000   697  G   W 223490 + 8 [kjournald]
 \end{verbatim}
 
-The header is the data in this line up to the 223490 (starting block). 
+The header is the data in this line up to the 223490 (starting block).
 
 The default output for all event types includes this header.
 
@@ -683,7 +711,7 @@ The default output for all event types includes this header.
 
 \begin{description}
   \item[C -- complete] If a payload is present, this is presented between
-  parenthesis following the header, followed by the error value. 
+  parenthesis following the header, followed by the error value.
 
   If no payload is present, the sector and number of blocks are presented
   (with an intervening plus (+) character). If the \emph{-t} option
@@ -769,24 +797,24 @@ Files which include $<linux/blktrace.h>$ are supplied with the following
 kernel routine invocable interfaces:
 
 \begin{description}
-  \item[blk\_add\_trace\_rq(struct request\_queue *q, struct request\_queue 
+  \item[blk\_add\_trace\_rq(struct request\_queue *q, struct request\_queue
   								*rq, u32 what)]
 	Adds a trace event describing the state change of the passed in
 	request\_queue. The \emph{what} parameter describes the change in
-	the request\_queue state, and is one of the request queue action 
+	the request\_queue state, and is one of the request queue action
 	specifiers -- BLK\_TA\_QUEUE, BLK\_TA\_REQUEUE, BLK\_TA\_ISSUE,
 	or BLK\_TA\_COMPLETE.
 
-  \item[blk\_add\_trace\_bio(struct request\_queue *q, struct bio *bio, 
+  \item[blk\_add\_trace\_bio(struct request\_queue *q, struct bio *bio,
   								u32 what)]
 	Adds a trace event for the BIO passed in. The \emph{what} parameter
 	describes the action being performed on the BIO, and is one of
 	BLK\_TA\_BACKMERGE, BLK\_TA\_FRONTMERGE, or BLK\_TA\_QUEUE.
 
-  \item[blk\_add\_trace\_generic(struct request\_queue *q, struct bio *bio, 
+  \item[blk\_add\_trace\_generic(struct request\_queue *q, struct bio *bio,
 							int rw, u32 what)]
 	Adds a \emph{generic} trace event -- not one of the request queue
-	or BIO traces. The \emph{what} parameter describes the action being 
+	or BIO traces. The \emph{what} parameter describes the action being
 	performed on the BIO (if bio is non-NULL), and is one of
 	BLK\_TA\_PLUG, BLK\_TA\_GETRQ or BLK\_TA\_SLEEPRQ.
 
-- 
1.5.4.3


--------------050808010508080905010104--
