Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbZGFPo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbZGFPo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZGFPkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:40:32 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42454 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZGFPjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:39:43 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 15/16] drbd: documentation
Date: Mon,  6 Jul 2009 17:39:34 +0200
Message-Id: <1246894775-10855-16-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1246894775-10855-15-git-send-email-philipp.reisner@linbit.com>
References: <1246894775-10855-1-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-2-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-3-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-4-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-5-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-6-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-7-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-8-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-9-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-10-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-11-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-12-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-13-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-14-git-send-email-philipp.reisner@linbit.com>
 <1246894775-10855-15-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some documentation, and pointers to more documentation.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

---
diff --git a/Documentation/blockdev/drbd/README.txt b/Documentation/blockdev/drbd/README.txt
new file mode 100644
index 0000000..627b0a1
--- /dev/null
+++ b/Documentation/blockdev/drbd/README.txt
@@ -0,0 +1,16 @@
+Description
+
+  DRBD is a shared-nothing, synchronously replicated block device. It
+  is designed to serve as a building block for high availability
+  clusters and in this context, is a "drop-in" replacement for shared
+  storage. Simplistically, you could see it as a network RAID 1.
+
+  Please visit http://www.drbd.org to find out more.
+
+The here included files are intended to help understand the implementation
+
+DRBD-8.3-data-packets.svg, DRBD-data-packets.svg  
+  relates some functions, and write packets.
+
+conn-states-8.dot, disk-states-8.dot, node-states-8.dot
+  The sub graphs of DRBD's state transitions
diff --git a/Documentation/blockdev/drbd/conn-states-8.dot b/Documentation/blockdev/drbd/conn-states-8.dot
new file mode 100644
index 0000000..025e8cf
--- /dev/null
+++ b/Documentation/blockdev/drbd/conn-states-8.dot
@@ -0,0 +1,18 @@
+digraph conn_states {
+	StandAllone  -> WFConnection   [ label = "ioctl_set_net()" ]
+	WFConnection -> Unconnected    [ label = "unable to bind()" ]
+	WFConnection -> WFReportParams [ label = "in connect() after accept" ]
+	WFReportParams -> StandAllone  [ label = "checks in receive_param()" ]
+	WFReportParams -> Connected    [ label = "in receive_param()" ]
+	WFReportParams -> WFBitMapS    [ label = "sync_handshake()" ]
+	WFReportParams -> WFBitMapT    [ label = "sync_handshake()" ]
+	WFBitMapS -> SyncSource        [ label = "receive_bitmap()" ]
+	WFBitMapT -> SyncTarget        [ label = "receive_bitmap()" ]
+	SyncSource -> Connected
+	SyncTarget -> Connected
+	SyncSource -> PausedSyncS
+	SyncTarget -> PausedSyncT
+	PausedSyncS -> SyncSource
+	PausedSyncT -> SyncTarget
+	Connected   -> WFConnection    [ label = "* on network error" ]
+}
diff --git a/Documentation/blockdev/drbd/disk-states-8.dot b/Documentation/blockdev/drbd/disk-states-8.dot
new file mode 100644
index 0000000..d06cfb4
--- /dev/null
+++ b/Documentation/blockdev/drbd/disk-states-8.dot
@@ -0,0 +1,16 @@
+digraph disk_states {
+	Diskless -> Inconsistent       [ label = "ioctl_set_disk()" ]
+	Diskless -> Consistent         [ label = "ioctl_set_disk()" ]
+	Diskless -> Outdated           [ label = "ioctl_set_disk()" ]
+	Consistent -> Outdated         [ label = "receive_param()" ]
+	Consistent -> UpToDate         [ label = "receive_param()" ]
+	Consistent -> Inconsistent     [ label = "start resync" ]
+	Outdated   -> Inconsistent     [ label = "start resync" ]
+	UpToDate   -> Inconsistent     [ label = "ioctl_replicate" ]
+	Inconsistent -> UpToDate       [ label = "resync completed" ]
+	Consistent -> Failed           [ label = "io completion error" ]
+	Outdated   -> Failed           [ label = "io completion error" ]
+	UpToDate   -> Failed           [ label = "io completion error" ]
+	Inconsistent -> Failed         [ label = "io completion error" ]
+	Failed -> Diskless             [ label = "sending notify to peer" ]
+}
diff --git a/Documentation/blockdev/drbd/node-states-8.dot b/Documentation/blockdev/drbd/node-states-8.dot
new file mode 100644
index 0000000..4a2b00c
--- /dev/null
+++ b/Documentation/blockdev/drbd/node-states-8.dot
@@ -0,0 +1,14 @@
+digraph node_states {
+	Secondary -> Primary           [ label = "ioctl_set_state()" ]
+	Primary   -> Secondary 	       [ label = "ioctl_set_state()" ]
+}
+
+digraph peer_states {
+	Secondary -> Primary           [ label = "recv state packet" ]
+	Primary   -> Secondary 	       [ label = "recv state packet" ]
+	Primary   -> Unknown 	       [ label = "connection lost" ]
+	Secondary  -> Unknown  	       [ label = "connection lost" ]
+	Unknown   -> Primary           [ label = "connected" ]
+	Unknown   -> Secondary         [ label = "connected" ]
+}
+
diff --git a/Documentation/blockdev/drbd/DRBD-data-packets.svg b/Documentation/blockdev/drbd/DRBD-data-packets.svg
new file mode 100644
index 0000000..48a1e21
--- /dev/null
+++ b/Documentation/blockdev/drbd/DRBD-data-packets.svg
@@ -0,0 +1,459 @@
+<?xml version="1.0" encoding="UTF-8" standalone="no"?>
+<!-- Created with Inkscape (http://www.inkscape.org/) -->
+<svg
+   xmlns:svg="http://www.w3.org/2000/svg"
+   xmlns="http://www.w3.org/2000/svg"
+   version="1.0"
+   width="210mm"
+   height="297mm"
+   viewBox="0 0 21000 29700"
+   id="svg2"
+   style="fill-rule:evenodd">
+  <defs
+     id="defs4" />
+  <g
+     id="Default"
+     style="visibility:visible">
+    <desc
+       id="desc176">Master slide</desc>
+  </g>
+  <path
+     d="M 11999,19601 L 11899,19301 L 12099,19301 L 11999,19601 z"
+     id="path189"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 11999,18801 L 11999,19361"
+     id="path193"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <path
+     d="M 7999,21401 L 7899,21101 L 8099,21101 L 7999,21401 z"
+     id="path205"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 7999,20601 L 7999,21161"
+     id="path209"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <path
+     d="M 11999,18801 L 11685,18840 L 11724,18644 L 11999,18801 z"
+     id="path221"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 7999,18001 L 11764,18754"
+     id="path225"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <text
+     x="-3023.845"
+     y="1106.8124"
+     transform="matrix(0.9895258,-0.1443562,0.1443562,0.9895258,0,0)"
+     id="text243"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="6115.1553 6344.1553 6555.1553 6784.1553 6962.1553 7051.1553 7228.1553 7457.1553 7635.1553 7813.1553 7885.1553"
+       y="21390.812"
+       id="tspan245">RSDataReply</tspan>
+  </text>
+  <path
+     d="M 7999,20601 L 8281,20458 L 8311,20655 L 7999,20601 z"
+     id="path255"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 11999,20001 L 8236,20565"
+     id="path259"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <text
+     x="3502.5356"
+     y="-2184.6621"
+     transform="matrix(0.9788674,0.2044961,-0.2044961,0.9788674,0,0)"
+     id="text277"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12321.536 12550.536 12761.536 12990.536 13168.536 13257.536 13434.536 13663.536 13841.536 14019.536 14196.536 14374.536 14535.536"
+       y="15854.338"
+       id="tspan279">RSDataRequest</tspan>
+  </text>
+  <text
+     id="text293"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4034 4263 4440 4703 4881 5042 5219 5397 5503 5681 5842 6003 6180 6341 6519 6625 6803 6980 7158 7336 7497 7586 7692"
+       y="17807"
+       id="tspan295">w_make_resync_request()</tspan>
+  </text>
+  <text
+     id="text309"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12199 12305 12483 12644 12821 12893 13054 13232 13410 13638 13816 13905 14083 14311 14489 14667 14845 15023 15184 15272 15378"
+       y="18806"
+       id="tspan311">receive_DataRequest()</tspan>
+  </text>
+  <text
+     id="text325"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12199 12377 12483 12660 12838 13016 13194 13372 13549 13621 13799 13977 14083 14261 14438 14616 14794 14955 15133 15294 15399"
+       y="19606"
+       id="tspan327">drbd_endio_read_sec()</tspan>
+  </text>
+  <text
+     id="text341"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12191 12420 12597 12775 12953 13131 13309 13486 13664 13770 13931 14109 14287 14375 14553 14731 14837 15015 15192 15298"
+       y="20007"
+       id="tspan343">w_e_end_rsdata_req()</tspan>
+  </text>
+  <text
+     id="text357"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4444 4550 4728 4889 5066 5138 5299 5477 5655 5883 6095 6324 6501 6590 6768 6997 7175 7352 7424 7585 7691"
+       y="20507"
+       id="tspan359">receive_RSDataReply()</tspan>
+  </text>
+  <text
+     id="text373"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4457 4635 4741 4918 5096 5274 5452 5630 5807 5879 6057 6235 6464 6569 6641 6730 6908 7086 7247 7425 7585 7691"
+       y="21407"
+       id="tspan375">drbd_endio_write_sec()</tspan>
+  </text>
+  <text
+     id="text389"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4647 4825 5003 5180 5358 5536 5714 5820 5997 6158 6319 6497 6658 6836 7013 7085 7263 7424 7585 7691"
+       y="21907"
+       id="tspan391">e_end_resync_block()</tspan>
+  </text>
+  <path
+     d="M 11999,22601 L 11685,22640 L 11724,22444 L 11999,22601 z"
+     id="path401"
+     style="fill:#000080;visibility:visible" />
+  <path
+     d="M 7999,21801 L 11764,22554"
+     id="path405"
+     style="fill:none;stroke:#000080;visibility:visible" />
+  <text
+     x="4290.3008"
+     y="-2369.6162"
+     transform="matrix(0.9788674,0.2044961,-0.2044961,0.9788674,0,0)"
+     id="text423"
+     style="font-size:318px;font-weight:400;fill:#000080;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="13610.301 13911.301 14016.301 14088.301 14177.301 14355.301 14567.301 14728.301"
+       y="19573.385"
+       id="tspan425">WriteAck</tspan>
+  </text>
+  <text
+     id="text439"
+     style="font-size:318px;font-weight:400;fill:#000080;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12199 12377 12555 12644 12821 13033 13105 13283 13444 13604 13816 13977 14138 14244"
+       y="22559"
+       id="tspan441">got_BlockAck()</tspan>
+  </text>
+  <text
+     id="text455"
+     style="font-size:423px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="7999 8304 8541 8753 8964 9201 9413 9531 9769 9862 10099 10310 10522 10734 10852 10971 11208 11348 11585 11822"
+       y="16877"
+       id="tspan457">Resync blocks, 4-32K</tspan>
+  </text>
+  <path
+     d="M 12000,7601 L 11900,7301 L 12100,7301 L 12000,7601 z"
+     id="path467"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 12000,6801 L 12000,7361"
+     id="path471"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <path
+     d="M 12000,6801 L 11686,6840 L 11725,6644 L 12000,6801 z"
+     id="path483"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 8000,6001 L 11765,6754"
+     id="path487"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <text
+     x="-1288.1796"
+     y="1279.7666"
+     transform="matrix(0.9895258,-0.1443562,0.1443562,0.9895258,0,0)"
+     id="text505"
+     style="font-size:318px;font-weight:400;fill:#000080;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="8174.8208 8475.8203 8580.8203 8652.8203 8741.8203 8919.8203 9131.8203 9292.8203"
+       y="9516.7666"
+       id="tspan507">WriteAck</tspan>
+  </text>
+  <path
+     d="M 8000,8601 L 8282,8458 L 8312,8655 L 8000,8601 z"
+     id="path517"
+     style="fill:#000080;visibility:visible" />
+  <path
+     d="M 12000,8001 L 8237,8565"
+     id="path521"
+     style="fill:none;stroke:#000080;visibility:visible" />
+  <text
+     x="1065.6655"
+     y="-2097.7664"
+     transform="matrix(0.9788674,0.2044961,-0.2044961,0.9788674,0,0)"
+     id="text539"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="10682.666 10911.666 11088.666 11177.666"
+       y="4107.2339"
+       id="tspan541">Data</tspan>
+  </text>
+  <text
+     id="text555"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4746 4924 5030 5207 5385 5563 5826 6003 6164 6342 6520 6626 6803 6981 7159 7337 7498 7587 7692"
+       y="5505"
+       id="tspan557">drbd_make_request()</tspan>
+  </text>
+  <text
+     id="text571"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12200 12306 12484 12645 12822 12894 13055 13233 13411 13639 13817 13906 14084 14190"
+       y="6806"
+       id="tspan573">receive_Data()</tspan>
+  </text>
+  <text
+     id="text587"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12200 12378 12484 12661 12839 13017 13195 13373 13550 13622 13800 13978 14207 14312 14384 14473 14651 14829 14990 15168 15328 15434"
+       y="7606"
+       id="tspan589">drbd_endio_write_sec()</tspan>
+  </text>
+  <text
+     id="text603"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12192 12370 12548 12725 12903 13081 13259 13437 13509 13686 13847 14008 14114"
+       y="8007"
+       id="tspan605">e_end_block()</tspan>
+  </text>
+  <text
+     id="text619"
+     style="font-size:318px;font-weight:400;fill:#000080;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="5647 5825 6003 6092 6269 6481 6553 6731 6892 7052 7264 7425 7586 7692"
+       y="8606"
+       id="tspan621">got_BlockAck()</tspan>
+  </text>
+  <text
+     id="text635"
+     style="font-size:423px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="8000 8305 8542 8779 9016 9109 9346 9486 9604 9956 10049 10189 10328 10565 10705 10942 11179 11298 11603 11742 11835 11954 12191 12310 12428 12665 12902 13139 13279 13516 13753"
+       y="4877"
+       id="tspan637">Regular mirrored write, 512-32K</tspan>
+  </text>
+  <text
+     id="text651"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="5381 5610 5787 5948 6126 6304 6482 6659 6837 7015 7087 7265 7426 7587 7692"
+       y="6003"
+       id="tspan653">w_send_dblock()</tspan>
+  </text>
+  <path
+     d="M 8000,6800 L 7900,6500 L 8100,6500 L 8000,6800 z"
+     id="path663"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 8000,6000 L 8000,6560"
+     id="path667"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <text
+     id="text683"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4602 4780 4886 5063 5241 5419 5597 5775 5952 6024 6202 6380 6609 6714 6786 6875 7053 7231 7409 7515 7587 7692"
+       y="6905"
+       id="tspan685">drbd_endio_write_pri()</tspan>
+  </text>
+  <path
+     d="M 12000,13602 L 11900,13302 L 12100,13302 L 12000,13602 z"
+     id="path695"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 12000,12802 L 12000,13362"
+     id="path699"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <path
+     d="M 12000,12802 L 11686,12841 L 11725,12645 L 12000,12802 z"
+     id="path711"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 8000,12002 L 11765,12755"
+     id="path715"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <text
+     x="-2155.5266"
+     y="1201.5964"
+     transform="matrix(0.9895258,-0.1443562,0.1443562,0.9895258,0,0)"
+     id="text733"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="7202.4736 7431.4736 7608.4736 7697.4736 7875.4736 8104.4736 8282.4736 8459.4736 8531.4736"
+       y="15454.597"
+       id="tspan735">DataReply</tspan>
+  </text>
+  <path
+     d="M 8000,14602 L 8282,14459 L 8312,14656 L 8000,14602 z"
+     id="path745"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 12000,14002 L 8237,14566"
+     id="path749"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <text
+     x="2280.3804"
+     y="-2103.2141"
+     transform="matrix(0.9788674,0.2044961,-0.2044961,0.9788674,0,0)"
+     id="text767"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="11316.381 11545.381 11722.381 11811.381 11989.381 12218.381 12396.381 12573.381 12751.381 12929.381 13090.381"
+       y="9981.7861"
+       id="tspan769">DataRequest</tspan>
+  </text>
+  <text
+     id="text783"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4746 4924 5030 5207 5385 5563 5826 6003 6164 6342 6520 6626 6803 6981 7159 7337 7498 7587 7692"
+       y="11506"
+       id="tspan785">drbd_make_request()</tspan>
+  </text>
+  <text
+     id="text799"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12200 12306 12484 12645 12822 12894 13055 13233 13411 13639 13817 13906 14084 14312 14490 14668 14846 15024 15185 15273 15379"
+       y="12807"
+       id="tspan801">receive_DataRequest()</tspan>
+  </text>
+  <text
+     id="text815"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12200 12378 12484 12661 12839 13017 13195 13373 13550 13622 13800 13978 14084 14262 14439 14617 14795 14956 15134 15295 15400"
+       y="13607"
+       id="tspan817">drbd_endio_read_sec()</tspan>
+  </text>
+  <text
+     id="text831"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12192 12421 12598 12776 12954 13132 13310 13487 13665 13843 14021 14110 14288 14465 14571 14749 14927 15033"
+       y="14008"
+       id="tspan833">w_e_end_data_req()</tspan>
+  </text>
+  <g
+     id="g835"
+     style="visibility:visible">
+    <desc
+       id="desc837">Drawing</desc>
+    <text
+       id="text847"
+       style="font-size:318px;font-weight:400;fill:#008000;font-family:Helvetica embedded">
+      <tspan
+         x="4885 4991 5169 5330 5507 5579 5740 5918 6096 6324 6502 6591 6769 6997 7175 7353 7425 7586 7692"
+         y="14607"
+         id="tspan849">receive_DataReply()</tspan>
+    </text>
+  </g>
+  <text
+     id="text863"
+     style="font-size:423px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="8000 8305 8398 8610 8821 8914 9151 9363 9575 9693 9833 10070 10307 10544 10663 10781 11018 11255 11493 11632 11869 12106"
+       y="10878"
+       id="tspan865">Diskless read, 512-32K</tspan>
+  </text>
+  <text
+     id="text879"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="5029 5258 5435 5596 5774 5952 6130 6307 6413 6591 6769 6947 7125 7230 7408 7586 7692"
+       y="12004"
+       id="tspan881">w_send_read_req()</tspan>
+  </text>
+  <text
+     id="text895"
+     style="font-size:423px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="6961 7266 7571 7854 8159 8278 8515 8633 8870 9107 9226 9463 9581 9700 9793 10030"
+       y="2806"
+       id="tspan897">DRBD 8 data flow</tspan>
+  </text>
+  <path
+     d="M 3900,5300 L 3700,5300 L 3700,7000 L 3900,7000"
+     id="path907"
+     style="fill:none;stroke:#000000;visibility:visible" />
+  <path
+     d="M 3900,17600 L 3700,17600 L 3700,22000 L 3900,22000"
+     id="path919"
+     style="fill:none;stroke:#000000;visibility:visible" />
+  <path
+     d="M 16100,20000 L 16300,20000 L 16300,18500 L 16100,18500"
+     id="path931"
+     style="fill:none;stroke:#000000;visibility:visible" />
+  <text
+     id="text947"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="2126 2304 2376 2554 2731 2909 3087 3159 3337 3515 3587 3764 3870"
+       y="5202"
+       id="tspan949">al_begin_io()</tspan>
+  </text>
+  <text
+     id="text963"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="1632 1810 1882 2060 2220 2398 2661 2839 2910 3088 3177 3355 3533 3605 3783 3888"
+       y="7331"
+       id="tspan965">al_complete_io()</tspan>
+  </text>
+  <text
+     id="text979"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="2126 2232 2393 2571 2748 2926 3104 3176 3354 3531 3603 3781 3887"
+       y="17431"
+       id="tspan981">rs_begin_io()</tspan>
+  </text>
+  <text
+     id="text995"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="1626 1732 1893 2071 2231 2409 2672 2849 2921 3099 3188 3366 3544 3616 3793 3899"
+       y="22331"
+       id="tspan997">rs_complete_io()</tspan>
+  </text>
+  <text
+     id="text1011"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="16027 16133 16294 16472 16649 16827 17005 17077 17255 17432 17504 17682 17788"
+       y="18402"
+       id="tspan1013">rs_begin_io()</tspan>
+  </text>
+  <text
+     id="text1027"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="16115 16221 16382 16560 16720 16898 17161 17338 17410 17588 17677 17855 18033 18105 18282 18388"
+       y="20331"
+       id="tspan1029">rs_complete_io()</tspan>
+  </text>
+</svg>
diff --git a/Documentation/blockdev/drbd/DRBD-8.3-data-packets.svg b/Documentation/blockdev/drbd/DRBD-8.3-data-packets.svg
new file mode 100644
index 0000000..f87cfa0
--- /dev/null
+++ b/Documentation/blockdev/drbd/DRBD-8.3-data-packets.svg
@@ -0,0 +1,588 @@
+<?xml version="1.0" encoding="UTF-8" standalone="no"?>
+<!-- Created with Inkscape (http://www.inkscape.org/) -->
+<svg
+   xmlns:svg="http://www.w3.org/2000/svg"
+   xmlns="http://www.w3.org/2000/svg"
+   version="1.0"
+   width="210mm"
+   height="297mm"
+   viewBox="0 0 21000 29700"
+   id="svg2"
+   style="fill-rule:evenodd">
+  <defs
+     id="defs4" />
+  <g
+     id="Default"
+     style="visibility:visible">
+    <desc
+       id="desc180">Master slide</desc>
+  </g>
+  <path
+     d="M 11999,8601 L 11899,8301 L 12099,8301 L 11999,8601 z"
+     id="path193"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 11999,7801 L 11999,8361"
+     id="path197"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <path
+     d="M 7999,10401 L 7899,10101 L 8099,10101 L 7999,10401 z"
+     id="path209"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 7999,9601 L 7999,10161"
+     id="path213"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <path
+     d="M 11999,7801 L 11685,7840 L 11724,7644 L 11999,7801 z"
+     id="path225"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 7999,7001 L 11764,7754"
+     id="path229"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <g
+     transform="matrix(0.9895258,-0.1443562,0.1443562,0.9895258,-1244.4792,1416.5139)"
+     id="g245"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <text
+       id="text247">
+      <tspan
+         x="9139 9368 9579 9808 9986 10075 10252 10481 10659 10837 10909"
+         y="9284"
+         id="tspan249">RSDataReply</tspan>
+    </text>
+  </g>
+  <path
+     d="M 7999,9601 L 8281,9458 L 8311,9655 L 7999,9601 z"
+     id="path259"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 11999,9001 L 8236,9565"
+     id="path263"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <g
+     transform="matrix(0.9788674,0.2044961,-0.2044961,0.9788674,1620.9382,-1639.4947)"
+     id="g279"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <text
+       id="text281">
+      <tspan
+         x="8743 8972 9132 9310 9573 9801 10013 10242 10419 10597 10775 10953 11114"
+         y="7023"
+         id="tspan283">CsumRSRequest</tspan>
+    </text>
+  </g>
+  <text
+     id="text297"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4034 4263 4440 4703 4881 5042 5219 5397 5503 5681 5842 6003 6180 6341 6519 6625 6803 6980 7158 7336 7497 7586 7692"
+       y="5707"
+       id="tspan299">w_make_resync_request()</tspan>
+  </text>
+  <text
+     id="text313"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12199 12305 12483 12644 12821 12893 13054 13232 13410 13638 13816 13905 14083 14311 14489 14667 14845 15023 15184 15272 15378"
+       y="7806"
+       id="tspan315">receive_DataRequest()</tspan>
+  </text>
+  <text
+     id="text329"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12199 12377 12483 12660 12838 13016 13194 13372 13549 13621 13799 13977 14083 14261 14438 14616 14794 14955 15133 15294 15399"
+       y="8606"
+       id="tspan331">drbd_endio_read_sec()</tspan>
+  </text>
+  <text
+     id="text345"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12191 12420 12597 12775 12953 13131 13309 13486 13664 13825 13986 14164 14426 14604 14710 14871 15049 15154 15332 15510 15616"
+       y="9007"
+       id="tspan347">w_e_end_csum_rs_req()</tspan>
+  </text>
+  <text
+     id="text361"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4444 4550 4728 4889 5066 5138 5299 5477 5655 5883 6095 6324 6501 6590 6768 6997 7175 7352 7424 7585 7691"
+       y="9507"
+       id="tspan363">receive_RSDataReply()</tspan>
+  </text>
+  <text
+     id="text377"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4457 4635 4741 4918 5096 5274 5452 5630 5807 5879 6057 6235 6464 6569 6641 6730 6908 7086 7247 7425 7585 7691"
+       y="10407"
+       id="tspan379">drbd_endio_write_sec()</tspan>
+  </text>
+  <text
+     id="text393"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4647 4825 5003 5180 5358 5536 5714 5820 5997 6158 6319 6497 6658 6836 7013 7085 7263 7424 7585 7691"
+       y="10907"
+       id="tspan395">e_end_resync_block()</tspan>
+  </text>
+  <path
+     d="M 11999,11601 L 11685,11640 L 11724,11444 L 11999,11601 z"
+     id="path405"
+     style="fill:#000080;visibility:visible" />
+  <path
+     d="M 7999,10801 L 11764,11554"
+     id="path409"
+     style="fill:none;stroke:#000080;visibility:visible" />
+  <g
+     transform="matrix(0.9788674,0.2044961,-0.2044961,0.9788674,2434.7562,-1674.649)"
+     id="g425"
+     style="font-size:318px;font-weight:400;fill:#000080;visibility:visible;font-family:Helvetica embedded">
+    <text
+       id="text427">
+      <tspan
+         x="9320 9621 9726 9798 9887 10065 10277 10438"
+         y="10943"
+         id="tspan429">WriteAck</tspan>
+    </text>
+  </g>
+  <text
+     id="text443"
+     style="font-size:318px;font-weight:400;fill:#000080;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12199 12377 12555 12644 12821 13033 13105 13283 13444 13604 13816 13977 14138 14244"
+       y="11559"
+       id="tspan445">got_BlockAck()</tspan>
+  </text>
+  <text
+     id="text459"
+     style="font-size:423px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="7999 8304 8541 8778 8990 9201 9413 9650 10001 10120 10357 10594 10806 11043 11280 11398 11703 11940 12152 12364 12601 12812 12931 13049 13261 13498 13710 13947 14065 14302 14540 14658 14777 14870 15107 15225 15437 15649 15886"
+       y="4877"
+       id="tspan461">Checksum based Resync, case not in sync</tspan>
+  </text>
+  <text
+     id="text475"
+     style="font-size:423px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="6961 7266 7571 7854 8159 8299 8536 8654 8891 9010 9247 9484 9603 9840 9958 10077 10170 10407"
+       y="2806"
+       id="tspan477">DRBD-8.3 data flow</tspan>
+  </text>
+  <text
+     id="text491"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="5190 5419 5596 5774 5952 6113 6291 6468 6646 6824 6985 7146 7324 7586 7692"
+       y="7005"
+       id="tspan493">w_e_send_csum()</tspan>
+  </text>
+  <path
+     d="M 11999,17601 L 11899,17301 L 12099,17301 L 11999,17601 z"
+     id="path503"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 11999,16801 L 11999,17361"
+     id="path507"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <path
+     d="M 11999,16801 L 11685,16840 L 11724,16644 L 11999,16801 z"
+     id="path519"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 7999,16001 L 11764,16754"
+     id="path523"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <g
+     transform="matrix(0.9895258,-0.1443562,0.1443562,0.9895258,-2539.5806,1529.3491)"
+     id="g539"
+     style="font-size:318px;font-weight:400;fill:#000080;visibility:visible;font-family:Helvetica embedded">
+    <text
+       id="text541">
+      <tspan
+         x="9269 9498 9709 9798 9959 10048 10226 10437 10598 10776"
+         y="18265"
+         id="tspan543">RSIsInSync</tspan>
+    </text>
+  </g>
+  <path
+     d="M 7999,18601 L 8281,18458 L 8311,18655 L 7999,18601 z"
+     id="path553"
+     style="fill:#000080;visibility:visible" />
+  <path
+     d="M 11999,18001 L 8236,18565"
+     id="path557"
+     style="fill:none;stroke:#000080;visibility:visible" />
+  <g
+     transform="matrix(0.9788674,0.2044961,-0.2044961,0.9788674,3461.4027,-1449.3012)"
+     id="g573"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <text
+       id="text575">
+      <tspan
+         x="8743 8972 9132 9310 9573 9801 10013 10242 10419 10597 10775 10953 11114"
+         y="16023"
+         id="tspan577">CsumRSRequest</tspan>
+    </text>
+  </g>
+  <text
+     id="text591"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12199 12305 12483 12644 12821 12893 13054 13232 13410 13638 13816 13905 14083 14311 14489 14667 14845 15023 15184 15272 15378"
+       y="16806"
+       id="tspan593">receive_DataRequest()</tspan>
+  </text>
+  <text
+     id="text607"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12199 12377 12483 12660 12838 13016 13194 13372 13549 13621 13799 13977 14083 14261 14438 14616 14794 14955 15133 15294 15399"
+       y="17606"
+       id="tspan609">drbd_endio_read_sec()</tspan>
+  </text>
+  <text
+     id="text623"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12191 12420 12597 12775 12953 13131 13309 13486 13664 13825 13986 14164 14426 14604 14710 14871 15049 15154 15332 15510 15616"
+       y="18007"
+       id="tspan625">w_e_end_csum_rs_req()</tspan>
+  </text>
+  <text
+     id="text639"
+     style="font-size:318px;font-weight:400;fill:#000080;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="5735 5913 6091 6180 6357 6446 6607 6696 6874 7085 7246 7424 7585 7691"
+       y="18507"
+       id="tspan641">got_IsInSync()</tspan>
+  </text>
+  <text
+     id="text655"
+     style="font-size:423px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="7999 8304 8541 8778 8990 9201 9413 9650 10001 10120 10357 10594 10806 11043 11280 11398 11703 11940 12152 12364 12601 12812 12931 13049 13261 13498 13710 13947 14065 14159 14396 14514 14726 14937 15175"
+       y="13877"
+       id="tspan657">Checksum based Resync, case in sync</tspan>
+  </text>
+  <path
+     d="M 12000,24601 L 11900,24301 L 12100,24301 L 12000,24601 z"
+     id="path667"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 12000,23801 L 12000,24361"
+     id="path671"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <path
+     d="M 8000,26401 L 7900,26101 L 8100,26101 L 8000,26401 z"
+     id="path683"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 8000,25601 L 8000,26161"
+     id="path687"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <path
+     d="M 12000,23801 L 11686,23840 L 11725,23644 L 12000,23801 z"
+     id="path699"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 8000,23001 L 11765,23754"
+     id="path703"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <g
+     transform="matrix(0.9895258,-0.1443562,0.1443562,0.9895258,-3543.8452,1630.5143)"
+     id="g719"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <text
+       id="text721">
+      <tspan
+         x="9464 9710 9921 10150 10328 10505 10577"
+         y="25236"
+         id="tspan723">OVReply</tspan>
+    </text>
+  </g>
+  <path
+     d="M 8000,25601 L 8282,25458 L 8312,25655 L 8000,25601 z"
+     id="path733"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 12000,25001 L 8237,25565"
+     id="path737"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <g
+     transform="matrix(0.9788674,0.2044961,-0.2044961,0.9788674,4918.2801,-1381.2128)"
+     id="g753"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <text
+       id="text755">
+      <tspan
+         x="9142 9388 9599 9828 10006 10183 10361 10539 10700"
+         y="23106"
+         id="tspan757">OVRequest</tspan>
+    </text>
+  </g>
+  <text
+     id="text771"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12200 12306 12484 12645 12822 12894 13055 13233 13411 13656 13868 14097 14274 14452 14630 14808 14969 15058 15163"
+       y="23806"
+       id="tspan773">receive_OVRequest()</tspan>
+  </text>
+  <text
+     id="text787"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12200 12378 12484 12661 12839 13017 13195 13373 13550 13622 13800 13978 14084 14262 14439 14617 14795 14956 15134 15295 15400"
+       y="24606"
+       id="tspan789">drbd_endio_read_sec()</tspan>
+  </text>
+  <text
+     id="text803"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12192 12421 12598 12776 12954 13132 13310 13487 13665 13843 14004 14182 14288 14465 14643 14749"
+       y="25007"
+       id="tspan805">w_e_end_ov_req()</tspan>
+  </text>
+  <text
+     id="text819"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="5101 5207 5385 5546 5723 5795 5956 6134 6312 6557 6769 6998 7175 7353 7425 7586 7692"
+       y="25507"
+       id="tspan821">receive_OVReply()</tspan>
+  </text>
+  <text
+     id="text835"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4492 4670 4776 4953 5131 5309 5487 5665 5842 5914 6092 6270 6376 6554 6731 6909 7087 7248 7426 7587 7692"
+       y="26407"
+       id="tspan837">drbd_endio_read_sec()</tspan>
+  </text>
+  <text
+     id="text851"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4902 5131 5308 5486 5664 5842 6020 6197 6375 6553 6714 6892 6998 7175 7353 7425 7586 7692"
+       y="26907"
+       id="tspan853">w_e_end_ov_reply()</tspan>
+  </text>
+  <path
+     d="M 12000,27601 L 11686,27640 L 11725,27444 L 12000,27601 z"
+     id="path863"
+     style="fill:#000080;visibility:visible" />
+  <path
+     d="M 8000,26801 L 11765,27554"
+     id="path867"
+     style="fill:none;stroke:#000080;visibility:visible" />
+  <g
+     transform="matrix(0.9788674,0.2044961,-0.2044961,0.9788674,5704.1907,-1328.312)"
+     id="g883"
+     style="font-size:318px;font-weight:400;fill:#000080;visibility:visible;font-family:Helvetica embedded">
+    <text
+       id="text885">
+      <tspan
+         x="9279 9525 9736 9965 10143 10303 10481 10553"
+         y="26935"
+         id="tspan887">OVResult</tspan>
+    </text>
+  </g>
+  <text
+     id="text901"
+     style="font-size:318px;font-weight:400;fill:#000080;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="12200 12378 12556 12645 12822 13068 13280 13508 13686 13847 14025 14097 14185 14291"
+       y="27559"
+       id="tspan903">got_OVResult()</tspan>
+  </text>
+  <text
+     id="text917"
+     style="font-size:423px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="8000 8330 8567 8660 8754 8991 9228 9346 9558 9795 9935 10028 10146"
+       y="21877"
+       id="tspan919">Online verify</tspan>
+  </text>
+  <text
+     id="text933"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4641 4870 5047 5310 5488 5649 5826 6004 6182 6343 6521 6626 6804 6982 7160 7338 7499 7587 7693"
+       y="23005"
+       id="tspan935">w_make_ov_request()</tspan>
+  </text>
+  <path
+     d="M 8000,6500 L 7900,6200 L 8100,6200 L 8000,6500 z"
+     id="path945"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 8000,5700 L 8000,6260"
+     id="path949"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <path
+     d="M 3900,5500 L 3700,5500 L 3700,11000 L 3900,11000"
+     id="path961"
+     style="fill:none;stroke:#000000;visibility:visible" />
+  <path
+     d="M 3900,14500 L 3700,14500 L 3700,18600 L 3900,18600"
+     id="path973"
+     style="fill:none;stroke:#000000;visibility:visible" />
+  <path
+     d="M 3900,22800 L 3700,22800 L 3700,26900 L 3900,26900"
+     id="path985"
+     style="fill:none;stroke:#000000;visibility:visible" />
+  <text
+     id="text1001"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4492 4670 4776 4953 5131 5309 5487 5665 5842 5914 6092 6270 6376 6554 6731 6909 7087 7248 7426 7587 7692"
+       y="6506"
+       id="tspan1003">drbd_endio_read_sec()</tspan>
+  </text>
+  <text
+     id="text1017"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4034 4263 4440 4703 4881 5042 5219 5397 5503 5681 5842 6003 6180 6341 6519 6625 6803 6980 7158 7336 7497 7586 7692"
+       y="14708"
+       id="tspan1019">w_make_resync_request()</tspan>
+  </text>
+  <text
+     id="text1033"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="5190 5419 5596 5774 5952 6113 6291 6468 6646 6824 6985 7146 7324 7586 7692"
+       y="16006"
+       id="tspan1035">w_e_send_csum()</tspan>
+  </text>
+  <path
+     d="M 8000,15501 L 7900,15201 L 8100,15201 L 8000,15501 z"
+     id="path1045"
+     style="fill:#008000;visibility:visible" />
+  <path
+     d="M 8000,14701 L 8000,15261"
+     id="path1049"
+     style="fill:none;stroke:#008000;visibility:visible" />
+  <text
+     id="text1065"
+     style="font-size:318px;font-weight:400;fill:#008000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="4492 4670 4776 4953 5131 5309 5487 5665 5842 5914 6092 6270 6376 6554 6731 6909 7087 7248 7426 7587 7692"
+       y="15507"
+       id="tspan1067">drbd_endio_read_sec()</tspan>
+  </text>
+  <path
+     d="M 16100,9000 L 16300,9000 L 16300,7500 L 16100,7500"
+     id="path1077"
+     style="fill:none;stroke:#000000;visibility:visible" />
+  <path
+     d="M 16100,18000 L 16300,18000 L 16300,16500 L 16100,16500"
+     id="path1089"
+     style="fill:none;stroke:#000000;visibility:visible" />
+  <path
+     d="M 16100,25000 L 16300,25000 L 16300,23500 L 16100,23500"
+     id="path1101"
+     style="fill:none;stroke:#000000;visibility:visible" />
+  <text
+     id="text1117"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="2026 2132 2293 2471 2648 2826 3004 3076 3254 3431 3503 3681 3787"
+       y="5402"
+       id="tspan1119">rs_begin_io()</tspan>
+  </text>
+  <text
+     id="text1133"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="2027 2133 2294 2472 2649 2827 3005 3077 3255 3432 3504 3682 3788"
+       y="14402"
+       id="tspan1135">rs_begin_io()</tspan>
+  </text>
+  <text
+     id="text1149"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="2026 2132 2293 2471 2648 2826 3004 3076 3254 3431 3503 3681 3787"
+       y="22602"
+       id="tspan1151">rs_begin_io()</tspan>
+  </text>
+  <text
+     id="text1165"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="1426 1532 1693 1871 2031 2209 2472 2649 2721 2899 2988 3166 3344 3416 3593 3699"
+       y="11302"
+       id="tspan1167">rs_complete_io()</tspan>
+  </text>
+  <text
+     id="text1181"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="1526 1632 1793 1971 2131 2309 2572 2749 2821 2999 3088 3266 3444 3516 3693 3799"
+       y="18931"
+       id="tspan1183">rs_complete_io()</tspan>
+  </text>
+  <text
+     id="text1197"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="1526 1632 1793 1971 2131 2309 2572 2749 2821 2999 3088 3266 3444 3516 3693 3799"
+       y="27231"
+       id="tspan1199">rs_complete_io()</tspan>
+  </text>
+  <text
+     id="text1213"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="16126 16232 16393 16571 16748 16926 17104 17176 17354 17531 17603 17781 17887"
+       y="7402"
+       id="tspan1215">rs_begin_io()</tspan>
+  </text>
+  <text
+     id="text1229"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="16127 16233 16394 16572 16749 16927 17105 17177 17355 17532 17604 17782 17888"
+       y="16331"
+       id="tspan1231">rs_begin_io()</tspan>
+  </text>
+  <text
+     id="text1245"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="16127 16233 16394 16572 16749 16927 17105 17177 17355 17532 17604 17782 17888"
+       y="23302"
+       id="tspan1247">rs_begin_io()</tspan>
+  </text>
+  <text
+     id="text1261"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="16115 16221 16382 16560 16720 16898 17161 17338 17410 17588 17677 17855 18033 18105 18282 18388"
+       y="9302"
+       id="tspan1263">rs_complete_io()</tspan>
+  </text>
+  <text
+     id="text1277"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="16115 16221 16382 16560 16720 16898 17161 17338 17410 17588 17677 17855 18033 18105 18282 18388"
+       y="18331"
+       id="tspan1279">rs_complete_io()</tspan>
+  </text>
+  <text
+     id="text1293"
+     style="font-size:318px;font-weight:400;fill:#000000;visibility:visible;font-family:Helvetica embedded">
+    <tspan
+       x="16126 16232 16393 16571 16731 16909 17172 17349 17421 17599 17688 17866 18044 18116 18293 18399"
+       y="25302"
+       id="tspan1295">rs_complete_io()</tspan>
+  </text>
+</svg>
diff --git a/Documentation/blockdev/drbd/drbd-connection-state-overview.dot b/Documentation/blockdev/drbd/drbd-connection-state-overview.dot
new file mode 100644
index 0000000..6d9cf0a
--- /dev/null
+++ b/Documentation/blockdev/drbd/drbd-connection-state-overview.dot
@@ -0,0 +1,85 @@
+// vim: set sw=2 sts=2 :
+digraph {
+  rankdir=BT
+  bgcolor=white
+
+  node [shape=plaintext]
+  node [fontcolor=black]
+
+  StandAlone     [ style=filled,fillcolor=gray,label=StandAlone ]
+
+  node [fontcolor=lightgray]
+
+  Unconnected    [ label=Unconnected ]
+
+  CommTrouble [ shape=record,
+    label="{communication loss|{Timeout|BrokenPipe|NetworkFailure}}" ]
+
+  node [fontcolor=gray]
+
+  subgraph cluster_try_connect {
+    label="try to connect, handshake"
+    rank=max
+    WFConnection   [ label=WFConnection ]
+    WFReportParams [ label=WFReportParams ]
+  }
+
+  TearDown       [ label=TearDown ]
+
+  Connected      [ label=Connected,style=filled,fillcolor=green,fontcolor=black ]
+
+  node [fontcolor=lightblue]
+
+  StartingSyncS  [ label=StartingSyncS ]
+  StartingSyncT  [ label=StartingSyncT ]
+
+  subgraph cluster_bitmap_exchange {
+    node [fontcolor=red]
+    fontcolor=red
+    label="new application (WRITE?) requests blocked\lwhile bitmap is exchanged"
+
+    WFBitMapT      [ label=WFBitMapT ]
+    WFSyncUUID     [ label=WFSyncUUID ]
+    WFBitMapS      [ label=WFBitMapS ]
+  }
+
+  node [fontcolor=blue]
+
+  cluster_resync [ shape=record,label="{<any>resynchronisation process running\l'concurrent' application requests allowed|{{<T>PausedSyncT\nSyncTarget}|{<S>PausedSyncS\nSyncSource}}}" ]
+
+  node [shape=box,fontcolor=black]
+
+  // drbdadm [label="drbdadm connect"]
+  // handshake [label="drbd_connect()\ndrbd_do_handshake\ndrbd_sync_handshake() etc."]
+  // comm_error [label="communication trouble"]
+
+  //
+  // edges
+  // --------------------------------------
+
+  StandAlone -> Unconnected [ label="drbdadm connect" ]
+  Unconnected -> StandAlone  [ label="drbdadm disconnect\lor serious communication trouble" ]
+  Unconnected -> WFConnection [ label="receiver thread is started" ]
+  WFConnection -> WFReportParams [ headlabel="accept()\land/or                        \lconnect()\l" ]
+
+  WFReportParams -> StandAlone [ label="during handshake\lpeers do not agree\labout something essential" ]
+  WFReportParams -> Connected [ label="data identical\lno sync needed",color=green,fontcolor=green ]
+
+    WFReportParams -> WFBitMapS
+    WFReportParams -> WFBitMapT
+    WFBitMapT -> WFSyncUUID [minlen=0.1,constraint=false]
+
+      WFBitMapS -> cluster_resync:S
+      WFSyncUUID -> cluster_resync:T
+
+  edge [color=green]
+  cluster_resync:any -> Connected [ label="resnyc done",fontcolor=green ]
+
+  edge [color=red]
+  WFReportParams -> CommTrouble
+  Connected -> CommTrouble
+  cluster_resync:any -> CommTrouble
+  edge [color=black]
+  CommTrouble -> Unconnected [label="receiver thread is stopped" ]
+
+}
