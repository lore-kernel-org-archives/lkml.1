Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYJDTgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYJDTgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYJDTgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:36:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:11595 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbYJDTgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=dmcvyqDHCLvUxVVfR3qlRpTA5P7C60lrKzligSfEiuIQCObN3hLmukxkLACGqSaDfD
         XZKhqEzfgv7liXIDjRtytCRaCAfgdm1p/wIiDs7Q8EsZDoFWGBjYJQm/AbyyLwL5z2Qf
         XpIxjjMg73Gs2ZQPwzaJTPmeQhbmXUSGChIbc=
Message-ID: <48E7C594.4030400@gmail.com>
Date: Sat, 04 Oct 2008 21:35:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: mingo@elte.hu
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org, arjan@infradead.org,
       alan-jenkins@tuffmail.co.uk
Subject: [PATCH -tip] Fastboot: fix initcalls disposition in bootgraph.pl
Content-Type: multipart/mixed;
 boundary="------------030609070204050201090008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030609070204050201090008
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

When bootgraph.pl parses a file, it gives one row
for each initcall's pid. But only few of them will
be displayed => the longest.
This patch corrects it by giving only a rows for pids
which have initcalls that will be displayed.
You can see the result in attachment, before and after the patch.

Ingo, could you please revert the commit b4bc656397071b18c99e85d9181f076e44de8a99 which was a false solution
to solve this problem. Thanks.


(I'm sorry if the patch doesn't look smart. I've
never touch a line in perl until now).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 scripts/bootgraph.pl |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
index 2243353..5e7316e 100644
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -37,13 +37,13 @@
 # 	dmesg | perl scripts/bootgraph.pl > output.svg
 #
 
-my @rows;
-my %start, %end, %row;
+my %start, %end;
 my $done = 0;
-my $rowcount = 0;
 my $maxtime = 0;
 my $firsttime = 100;
 my $count = 0;
+my %pids;
+
 while (<>) {
 	my $line = $_;
 	if ($line =~ /([0-9\.]+)\] calling  ([a-zA-Z0-9\_]+)\+/) {
@@ -54,14 +54,8 @@ while (<>) {
 				$firsttime = $1;
 			}
 		}
-		$row{$func} = 1;
 		if ($line =~ /\@ ([0-9]+)/) {
-			my $pid = $1;
-			if (!defined($rows[$pid])) {
-				$rowcount = $rowcount + 1;
-				$rows[$pid] = $rowcount;
-			}
-			$row{$func} = $rows[$pid];
+			$pids{$func} = $1;
 		}
 		$count = $count + 1;
 	}
@@ -109,17 +103,25 @@ $styles[11] = "fill:rgb(128,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(
 my $mult = 950.0 / ($maxtime - $firsttime);
 my $threshold = ($maxtime - $firsttime) / 60.0;
 my $stylecounter = 0;
+my %rows;
+my $rowscount = 1;
 while (($key,$value) = each %start) {
 	my $duration = $end{$key} - $start{$key};
 
 	if ($duration >= $threshold) {
 		my $s, $s2, $e, $y;
+		$pid = $pids{$key};
+
+		if (!defined($rows{$pid})) {
+			$rows{$pid} = $rowscount;
+			$rowscount = $rowscount + 1;
+		}
 		$s = ($value - $firsttime) * $mult;
 		$s2 = $s + 6;
 		$e = ($end{$key} - $firsttime) * $mult;
 		$w = $e - $s;
 
-		$y = $row{$key} * 150;
+		$y = $rows{$pid} * 150;
 		$y2 = $y + 4;
 
 		$style = $styles[$stylecounter];

--------------030609070204050201090008
Content-Type: image/svg+xml;
 name="before.svg"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="before.svg"

PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PiAKPHN2ZyB3aWR0aD0iMTAw
MCIgaGVpZ2h0PSIxMDAlIiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9y
Zy8yMDAwL3N2ZyI+CjxyZWN0IHg9IjM2NS44MDY0MDMzNjUxNyIgd2lkdGg9IjIxLjM1MjQ2
NTgwMjA3NjMiIHk9IjIyNTAiIGhlaWdodD0iMTQ1IiBzdHlsZT0iZmlsbDpyZ2IoMCwwLDI1
NSk7ZmlsbC1vcGFjaXR5OjAuNTtzdHJva2Utd2lkdGg6MTtzdHJva2U6cmdiKDAsMCwwKSIv
Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSgzNzEuODA2NDAzMzY1MTcsMjI1NCkgcm90
YXRlKDkwKSI+ZWhjaV9oY2RfaW5pdDwvdGV4dD4KPHJlY3QgeD0iMTAuNTg4NjEwODYwNjQz
OSIgd2lkdGg9IjU0LjM1ODU1Nzk1MzI2NTYiIHk9IjE1MCIgaGVpZ2h0PSIxNDUiIHN0eWxl
PSJmaWxsOnJnYigwLDI1NSwwKTtmaWxsLW9wYWNpdHk6MC41O3N0cm9rZS13aWR0aDoxO3N0
cm9rZTpyZ2IoMCwwLDApIi8+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDE2LjU4ODYx
MDg2MDY0MzksMTU0KSByb3RhdGUoOTApIj5waWl4X2lkZV9pbml0PC90ZXh0Pgo8cmVjdCB4
PSIzNjguMTU4MDE1NDE2MTE3IiB3aWR0aD0iMTkuMDA3NjE0ODk1NDEzNyIgeT0iMjQwMCIg
aGVpZ2h0PSIxNDUiIHN0eWxlPSJmaWxsOnJnYigyNTUsMCwyMCk7ZmlsbC1vcGFjaXR5OjAu
NTtzdHJva2Utd2lkdGg6MTtzdHJva2U6cmdiKDAsMCwwKSIvPgo8dGV4dCB0cmFuc2Zvcm09
InRyYW5zbGF0ZSgzNzQuMTU4MDE1NDE2MTE3LDI0MDQpIHJvdGF0ZSg5MCkiPnVoY2lfaGNk
X2luaXQ8L3RleHQ+CjxyZWN0IHg9IjY1LjM4MzcxMDk0Nzg4NDEiIHdpZHRoPSI0Mi40ODk3
MjI0MTIxNjIiIHk9IjE1MCIgaGVpZ2h0PSIxNDUiIHN0eWxlPSJmaWxsOnJnYigyNTUsMjU1
LDIwKTtmaWxsLW9wYWNpdHk6MC41O3N0cm9rZS13aWR0aDoxO3N0cm9rZTpyZ2IoMCwwLDAp
Ii8+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDcxLjM4MzcxMDk0Nzg4NDEsMTU0KSBy
b3RhdGUoOTApIj5haGNpX2luaXQ8L3RleHQ+CjxyZWN0IHg9IjQwNS4xNDYyMzkzMTMwMDQi
IHdpZHRoPSIxNy4zNDUwODE5OTI2ODEyIiB5PSIyNzAwIiBoZWlnaHQ9IjE0NSIgc3R5bGU9
ImZpbGw6cmdiKDI1NSwwLDI1NSk7ZmlsbC1vcGFjaXR5OjAuNTtzdHJva2Utd2lkdGg6MTtz
dHJva2U6cmdiKDAsMCwwKSIvPgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSg0MTEuMTQ2
MjM5MzEzMDA0LDI3MDQpIHJvdGF0ZSg5MCkiPmpveWRldl9pbml0PC90ZXh0Pgo8dGV4dCB0
cmFuc2Zvcm09InRyYW5zbGF0ZSgwLDg5KSByb3RhdGUoOTApIj4wLjE4PC90ZXh0Pgo8dGV4
dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSg2My4zMzMzMzMzMzMzMzMzLDg5KSByb3RhdGUoOTAp
Ij4yLjQ4PC90ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxMjYuNjY2NjY2NjY2
NjY3LDg5KSByb3RhdGUoOTApIj40Ljc4PC90ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5z
bGF0ZSgxOTAsODkpIHJvdGF0ZSg5MCkiPjcuMDk8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0i
dHJhbnNsYXRlKDI1My4zMzMzMzMzMzMzMzMsODkpIHJvdGF0ZSg5MCkiPjkuMzk8L3RleHQ+
Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDMxNi42NjY2NjY2NjY2NjcsODkpIHJvdGF0
ZSg5MCkiPjExLjc8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDM4MCw4OSkg
cm90YXRlKDkwKSI+MTQ8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDQ0My4z
MzMzMzMzMzMzMzMsODkpIHJvdGF0ZSg5MCkiPjE2LjMxPC90ZXh0Pgo8dGV4dCB0cmFuc2Zv
cm09InRyYW5zbGF0ZSg1MDYuNjY2NjY2NjY2NjY3LDg5KSByb3RhdGUoOTApIj4xOC42MTwv
dGV4dD4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNTcwLDg5KSByb3RhdGUoOTApIj4y
MC45MjwvdGV4dD4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNjMzLjMzMzMzMzMzMzMz
Myw4OSkgcm90YXRlKDkwKSI+MjMuMjI8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNs
YXRlKDY5Ni42NjY2NjY2NjY2NjcsODkpIHJvdGF0ZSg5MCkiPjI1LjUzPC90ZXh0Pgo8dGV4
dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSg3NjAsODkpIHJvdGF0ZSg5MCkiPjI3LjgzPC90ZXh0
Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSg4MjMuMzMzMzMzMzMzMzM0LDg5KSByb3Rh
dGUoOTApIj4zMC4xNDwvdGV4dD4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoODg2LjY2
NjY2NjY2NjY2Nyw4OSkgcm90YXRlKDkwKSI+MzIuNDQ8L3RleHQ+Cjwvc3ZnPgo=
--------------030609070204050201090008
Content-Type: image/svg+xml;
 name="after.svg"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="after.svg"

PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PiAKPHN2ZyB3aWR0aD0iMTAw
MCIgaGVpZ2h0PSIxMDAlIiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9y
Zy8yMDAwL3N2ZyI+CjxyZWN0IHg9IjM2NS44MDY0MDMzNjUxNyIgd2lkdGg9IjIxLjM1MjQ2
NTgwMjA3NjMiIHk9IjE1MCIgaGVpZ2h0PSIxNDUiIHN0eWxlPSJmaWxsOnJnYigwLDAsMjU1
KTtmaWxsLW9wYWNpdHk6MC41O3N0cm9rZS13aWR0aDoxO3N0cm9rZTpyZ2IoMCwwLDApIi8+
Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDM3MS44MDY0MDMzNjUxNywxNTQpIHJvdGF0
ZSg5MCkiPmVoY2lfaGNkX2luaXQ8L3RleHQ+CjxyZWN0IHg9IjEwLjU4ODYxMDg2MDY0Mzki
IHdpZHRoPSI1NC4zNTg1NTc5NTMyNjU2IiB5PSIzMDAiIGhlaWdodD0iMTQ1IiBzdHlsZT0i
ZmlsbDpyZ2IoMCwyNTUsMCk7ZmlsbC1vcGFjaXR5OjAuNTtzdHJva2Utd2lkdGg6MTtzdHJv
a2U6cmdiKDAsMCwwKSIvPgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxNi41ODg2MTA4
NjA2NDM5LDMwNCkgcm90YXRlKDkwKSI+cGlpeF9pZGVfaW5pdDwvdGV4dD4KPHJlY3QgeD0i
MzY4LjE1ODAxNTQxNjExNyIgd2lkdGg9IjE5LjAwNzYxNDg5NTQxMzciIHk9IjQ1MCIgaGVp
Z2h0PSIxNDUiIHN0eWxlPSJmaWxsOnJnYigyNTUsMCwyMCk7ZmlsbC1vcGFjaXR5OjAuNTtz
dHJva2Utd2lkdGg6MTtzdHJva2U6cmdiKDAsMCwwKSIvPgo8dGV4dCB0cmFuc2Zvcm09InRy
YW5zbGF0ZSgzNzQuMTU4MDE1NDE2MTE3LDQ1NCkgcm90YXRlKDkwKSI+dWhjaV9oY2RfaW5p
dDwvdGV4dD4KPHJlY3QgeD0iNjUuMzgzNzEwOTQ3ODg0MSIgd2lkdGg9IjQyLjQ4OTcyMjQx
MjE2MiIgeT0iMzAwIiBoZWlnaHQ9IjE0NSIgc3R5bGU9ImZpbGw6cmdiKDI1NSwyNTUsMjAp
O2ZpbGwtb3BhY2l0eTowLjU7c3Ryb2tlLXdpZHRoOjE7c3Ryb2tlOnJnYigwLDAsMCkiLz4K
PHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNzEuMzgzNzEwOTQ3ODg0MSwzMDQpIHJvdGF0
ZSg5MCkiPmFoY2lfaW5pdDwvdGV4dD4KPHJlY3QgeD0iNDA1LjE0NjIzOTMxMzAwNCIgd2lk
dGg9IjE3LjM0NTA4MTk5MjY4MTIiIHk9IjYwMCIgaGVpZ2h0PSIxNDUiIHN0eWxlPSJmaWxs
OnJnYigyNTUsMCwyNTUpO2ZpbGwtb3BhY2l0eTowLjU7c3Ryb2tlLXdpZHRoOjE7c3Ryb2tl
OnJnYigwLDAsMCkiLz4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNDExLjE0NjIzOTMx
MzAwNCw2MDQpIHJvdGF0ZSg5MCkiPmpveWRldl9pbml0PC90ZXh0Pgo8dGV4dCB0cmFuc2Zv
cm09InRyYW5zbGF0ZSgwLDg5KSByb3RhdGUoOTApIj4wLjE4PC90ZXh0Pgo8dGV4dCB0cmFu
c2Zvcm09InRyYW5zbGF0ZSg2My4zMzMzMzMzMzMzMzMzLDg5KSByb3RhdGUoOTApIj4yLjQ4
PC90ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxMjYuNjY2NjY2NjY2NjY3LDg5
KSByb3RhdGUoOTApIj40Ljc4PC90ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSgx
OTAsODkpIHJvdGF0ZSg5MCkiPjcuMDk8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNs
YXRlKDI1My4zMzMzMzMzMzMzMzMsODkpIHJvdGF0ZSg5MCkiPjkuMzk8L3RleHQ+Cjx0ZXh0
IHRyYW5zZm9ybT0idHJhbnNsYXRlKDMxNi42NjY2NjY2NjY2NjcsODkpIHJvdGF0ZSg5MCki
PjExLjc8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDM4MCw4OSkgcm90YXRl
KDkwKSI+MTQ8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDQ0My4zMzMzMzMz
MzMzMzMsODkpIHJvdGF0ZSg5MCkiPjE2LjMxPC90ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09InRy
YW5zbGF0ZSg1MDYuNjY2NjY2NjY2NjY3LDg5KSByb3RhdGUoOTApIj4xOC42MTwvdGV4dD4K
PHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNTcwLDg5KSByb3RhdGUoOTApIj4yMC45Mjwv
dGV4dD4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNjMzLjMzMzMzMzMzMzMzMyw4OSkg
cm90YXRlKDkwKSI+MjMuMjI8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDY5
Ni42NjY2NjY2NjY2NjcsODkpIHJvdGF0ZSg5MCkiPjI1LjUzPC90ZXh0Pgo8dGV4dCB0cmFu
c2Zvcm09InRyYW5zbGF0ZSg3NjAsODkpIHJvdGF0ZSg5MCkiPjI3LjgzPC90ZXh0Pgo8dGV4
dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSg4MjMuMzMzMzMzMzMzMzM0LDg5KSByb3RhdGUoOTAp
Ij4zMC4xNDwvdGV4dD4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoODg2LjY2NjY2NjY2
NjY2Nyw4OSkgcm90YXRlKDkwKSI+MzIuNDQ8L3RleHQ+Cjwvc3ZnPgo=
--------------030609070204050201090008--
