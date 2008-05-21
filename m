Return-Path: <linux-kernel-owner+w=401wt.eu-S936524AbYEURmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936524AbYEURmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936151AbYEURl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:41:59 -0400
Received: from westnet.com ([216.187.52.2]:40534 "EHLO westnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936174AbYEURlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:41:55 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 13:41:55 EDT
Date: Wed, 21 May 2008 13:34:56 -0400 (EDT)
From: Greg Smith <gsmith@gregsmith.com>
X-X-Sender: gsmith@westnet.com
To: lkml <linux-kernel@vger.kernel.org>
Subject: PostgreSQL pgbench performance regression in 2.6.23+
Message-ID: <Pine.GSO.4.64.0805211115390.8451@westnet.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-1804928587-1211383827=:8451"
Content-ID: <Pine.GSO.4.64.0805211131090.8451@westnet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-1804928587-1211383827=:8451
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <Pine.GSO.4.64.0805211131091.8451@westnet.com>

PostgreSQL ships with a simple database benchmarking tool named pgbench, 
in what's labeled the contrib section (in many distributions it's a 
separate package from the main server/client ones).  I see there's been 
some work done already improving how the PostgreSQL server works under the 
new scheduler (the "Poor PostgreSQL scaling on Linux 2.6.25-rc5" thread). 
I wanted to provide you a different test case using pgbench that has taken 
a sharp dive starting with 2.6.23, and the server improvement changes in 
2.6.25 actually made this problem worse.

I think it will be easy for someone else to replicate my results and I'll 
go over the exact procedure below.  To start with a view of how bad the 
regression is, here's a summary of the results on one system, an AMD X2 
4600+ running at 2.4GHz, with a few interesting kernels.  I threw in 
results from Solaris 10 on this system as a nice independant reference 
point.  The numbers here are transactions/second (TPS) running a simple 
read-only test over a 160MB data set, I took the median from 3 test runs:

Clients	2.6.9	2.6.22	2.6.24	2.6.25	Solaris
1	11173	11052	10526	10700	9656
2	18035	16352	14447	10370	14518
3	19365	15414	17784	9403	14062
4	18975	14290	16832	8882	14568
5	18652	14211	16356	8527	15062
6	17830	13291	16763	9473	15314
8	15837	12374	15343	9093	15164
10	14829	11218	10732	9057	14967
15	14053	11116	7460	7113	13944
20	13713	11412	7171	7017	13357
30	13454	11191	7049	6896	12987
40	13103	11062	7001	6820	12871
50	12311	11255	6915	6797	12858

That's the CentOS 4 2.6.9 kernel there, while the rest are stock ones I 
compiled with a minimum of fiddling from the defaults (just adding support 
for my SATA RAID card).  You can see a major drop with the recent kernels 
at high client loads, and the changes in 2.6.25 seem to have really hurt 
even the low client count ones.

The other recent hardware I have here, an Intel Q6600 based system, gives 
even more maddening results.  On successive benchmark runs, you can watch 
it break down only sometimes once you get just above 8 clients.  At 10 and 
15 clients, when I run it a few times, I'll sometimes get results in the 
good 25-30K TPS range, while others will give the 10K slow case.  It's not 
a smooth drop off like in the AMD case, the results from 10-15 are really 
unstable.  I've attached some files with 5 quick runs at each client load 
so you can see what I'm talking about.  On that system I was also able to 
test 2.6.26-rc2 which doesn't look all that different from 2.6.25.

All these results are running everything on the server using the default 
local sockets-based interface, which is relevant in the real world because 
that's how a web app hosted on the same system will talk to the database. 
If I switch to connecting to the database over TCP/IP and run the pgbench 
client on another system, the extra latency drops the single client case 
to ~3100TPS.  But the high client load cases are great--about 26K TPS at 
50 clients.  That result is attached as q6600-remote-2.6.25.txt, the 
remote client was running 2.6.20.  Since recent PostgreSQL results were 
also fine with sysbench as the benchmark driver, this suggests the problem 
here is actually related to the pgbench client itself and how it gets 
scheduled relative to the server backends, rather than being inherent to 
the server.

Replicating the test results
----------------------------

Onto replicating my results, which I hope works because I don't have too 
much time to test potential fixed kernels myself (I was supposed to be 
working on the PostgreSQL code until this sidetracked me).  I'll assume 
you can get the basic database going, if anybody needs help with that let 
me know.  There is one server tunable that needs to be adjusted before you 
can get useful PostgreSQL benchmarks from this (and many other) tests. 
In the root of the database directory, there will be a file named 
postgresql.conf.  Edit that and changed the setting for the shared_buffers 
parameter to 256MB to mimic my test setup.  You may need to bump up shmmax 
(this is the one list where I'm happy I don't have to explain what that 
means!).  Restart the server and check the logs to make sure it came back 
up, if shmmax is too low it will just tell you how big it needs to be and 
not start.

Now the basic procedure to run this test is:

-dropdb pgbench (if it's already there)
-createdb pgbench
-pgbench -i -s 10 pgbench       (makes about a 160MB database)
-pgbench -S -c <clients> -t 10000 pgbench

The idea is that you'll have a large enough data set to not fit in L2 
cache, but small enough that it all fits in PostgreSQL's dedicated memory 
(shared_buffers) so that it never has to ask the kernel to read a block. 
The "pgbench -i" initialization step will populate the server's memory and 
while that's all written to disk, it should stay in memory afterwards as 
well.  That's why I use this as a general CPU/L2/memory test as viewed 
from a PostgreSQL context, and as you can see from my results with this 
problem it's pretty sensitive to whether your setup is optimal or not.

To make this easier to run against a range of client loads, I've attached 
a script (selecttest.sh) that does the last two steps in the above. 
That's what I used to generate all the results I've attached.  If you've 
got the database setup such that you can run the psql client and pgbench 
is in your path, you should just be able to run that script and have it 
give you a set of results in a couple of minutes.  You can adjust which 
client loads and how many times it runs each by editing the script.

Addendum:  how pgbench works
----------------------------

pgbench works off "command scripts", which are a series of SQL commands 
with some extra benchmarking features implemented as a really simple 
programming language.  For example, the SELECT-only test run above, what 
you get when passing -S to pgbench, is implemented like this:

\\set naccounts 100000 * :scale
\\setrandom aid 1 :naccounts
SELECT abalance FROM accounts WHERE aid = :aid;

Here :scale is detected automatically by doing a count of a table in the 
database.

The pgbench client runs as a single process.  When pgbench starts, it 
iterates over each client, parsing the script until it hits a line that 
needs to be sent to the server.  At that point, it issues that command as 
an asynchronous request, then returns to the main loop.  Once every client 
is primed with a command, it enters a loop where it just waits for 
responses from them.

The main loop has all the open client connections in a fd_set.  Each time 
a select() on that set says there's been a response to at least one of the 
clients from the server, it sweeps through all the clients and feeds the 
next script line to any that are ready for one.  This proceeds until the 
target transaction count is reached.

This design is recognized as being only useful for smallish client loads. 
The results start dropping off very hard even on a fast machine with >100 
simulated clients as the single pgbench process struggles to respond to 
everyone who is ready on each pass through all the clients who got 
responses.  This makes pgbench particularly unsuitable for testing on 
systems with a large number of CPUs.  I find pgbench just can't keep up 
with the useful number of clients possible somewhere between 8 and 16 
cores.  I'm hoping the PostgreSQL community can rewrite it in a more 
efficient way before the next release comes out now that such hardware is 
starting to show up more running this database.  If that's the only way to 
resolve the issue outlined in this message, that's not intolerable, but a 
kernel fix would obviously be better.

I wanted to submit this here regardless because I'd really like for 
current versions to not have a big regression just because they were using 
a newer kernel, and it provides an interesting scheduler test case to add 
to the mix.  The fact that earlier Linux kernels and alternate ones like 
Solaris give pretty consistant results here says this programming approach 
isn't impossible for a kernel to support well, I just don't think this 
specific type of load has been considered in the test cases for the new 
scheduler yet.

--
* Greg Smith gsmith@gregsmith.com http://www.gregsmith.com Baltimore, MD
---559023410-1804928587-1211383827=:8451
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME=selecttest.sh
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.64.0805211130270.8451@westnet.com>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=selecttest.sh

IyEvYmluL2Jhc2gNCg0KdW5hbWUgLXByDQoNClNDQUxFPTEwDQpUT1RUUkFO
Uz0xMDAwMDANCg0KU0VUVElNRVM9Mw0KU0VUQ0xJRU5UUz0iMSAyIDMgNCA1
IDYgOCAxMCAxNSAyMCAzMCA0MCA1MCINCg0KVEVTVERCPSJwZ2JlbmNoIg0K
DQpwZ2JlbmNoIC1pIC1zICRTQ0FMRSAkVEVTVERCID4gL2Rldi9udWxsIDI+
JjENCg0KZm9yIEMgaW4gJFNFVENMSUVOVFM7IGRvDQogIFQ9MQ0KICB3aGls
ZSBbICRUIC1sZSAiJFNFVFRJTUVTIiBdOyBkbw0KICAgIFRSQU5TPWBleHBy
ICRUT1RUUkFOUyAvICRDYA0KICAgIHBnYmVuY2ggLVMgLW4gLWMgJEMgLXQg
JFRSQU5TICRURVNUREIgPiByZXN1bHRzLnR4dA0KICAgIFRQUz1gZ3JlcCAi
KGluY2x1ZGluZyBjb25uZWN0aW9ucyBlc3RhYmxpc2hpbmcpIiByZXN1bHRz
LnR4dCB8IGN1dCAtZCAiICIgLWYgM2ANCiAgICBlY2hvICRDICRUUFMNCiAg
ICBUPSQoKCAkVCArIDEpKQ0KICBkb25lDQpkb25lDQoNCnJtIC1mIHJlc3Vs
dHMudHh0DQo=

---559023410-1804928587-1211383827=:8451
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME=q6600-remote-2.6.25.txt
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.64.0805211204150.16929@westnet.com>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=q6600-remote-2.6.25.txt

Mi42LjI1IHg4Nl82NCAob24gc2VydmVyOyBjbGllbnQgcnVuIG9uIHJlbW90
ZSBob3N0IHdpdGgga2VybmVsIDIuNi4yMC0xNikNCjEgMzA1Ny44NDQxOTkN
CjEgMzA5Mi40ODIxNjMNCjEgMzEyMS45NTMzNjQNCjIgNTcyNy4xNDI2NTkN
CjIgNTkwOC4yOTczMTcNCjIgNTkyNi44ODg2MjgNCjMgOTM2My40Nzc1NDAN
CjMgOTQzMy4wODQ4MDENCjMgOTQzMS4xOTA3MTINCjQgMTMwMDQuNTMzNjQx
DQo0IDEyODk1LjM0Mzg0MA0KNCAxMjk0OS42MjU1NjgNCjUgMTU4NzQuNTM1
MjkzDQo1IDE2MjE1Ljc3NjE5OQ0KNSAxNTkwOS40MjU3MzANCjYgMTg1Nzku
MDc0OTYzDQo2IDE4NzEyLjU1ODE4Mg0KNiAxODQ1My4xNzc5ODYNCjggMjA4
NjcuMTA3NjE2DQo4IDIwNjExLjk4MjExNg0KOCAyMDgwOC45MzkxODcNCjEw
IDIyNjI5LjkwMjQyOQ0KMTAgMjI3MzkuMjk4NzE1DQoxMCAyMjIxMi41Nzcw
MjgNCjE1IDI2NjUzLjAyNjA2MQ0KMTUgMjU2NzIuMDY1NjE0DQoxNSAyNjQ4
My4yMjE5OTYNCjIwIDI3NTU3LjA0NTg0MQ0KMjAgMjYyMzcuODE0ODMxDQoy
MCAyODk1Ni41NzU4NTANCjMwIDIzMTY2Ljc4NTMzMQ0KMzAgMjY3MDIuMjU4
OTk3DQozMCAyODU4My45NzQxMDcNCjQwIDI3NTQxLjkwNDMxOQ0KNDAgMjU4
OTEuMTY3NTEzDQo0MCAyNjQ3Ni41OTI5NzENCjUwIDI2NDM0LjA4MTk5MQ0K
NTAgMjU2MzcuMTQwNjI4DQo1MCAyNjA5OS4wOTE0NjUNCg0K

---559023410-1804928587-1211383827=:8451
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME=q6600-results-2.6.25.txt
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.64.0805211204151.16929@westnet.com>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=q6600-results-2.6.25.txt

Mi42LjI1IHg4Nl82NA0KMSAxMDMzMC42NjA2ODgNCjEgMTEyNzEuNzU0OTEw
DQoxIDExMjgyLjEyNTU3MQ0KMSAxMTI1Ni4zNDA0MTUNCjEgMTEzMjUuMDUx
Mzk5DQoyIDEyNTA0LjczNzczMw0KMiAxMjU4OC4xMzQyNDgNCjIgMTI0NDEu
ODMxMzI4DQoyIDEyNDQ3LjYyMDQxMw0KMiAxMjU5My44NDYxOTMNCjMgMTI2
MjguNjY1Mjg2DQozIDEyNzY2LjgwMTY5NA0KMyAxMjc5Ny4wMjAyMTANCjMg
MTI5NTkuNzAzMDg1DQozIDEyOTA1LjcwMjg5NA0KNCAxMzk1OC4yODQ4MjgN
CjQgMTM5NzcuMzczNDI4DQo0IDE0MTA5LjE4NjE5NQ0KNCAxMzAzNC44Njk1
ODANCjQgMTMwMDUuMzM4NjkyDQo1IDExOTk0Ljk2MTE1Nw0KNSAxNDc2Ni4w
NDc0ODINCjUgMTQzNDQuMDE4NjIzDQo1IDEyNDA0LjA1MzA5OQ0KNSAxMjAw
Ny44NTkzODQNCjYgMTA5MTYuMjg5OTk0DQo2IDEyMTQ1LjA2NzQ2MA0KNiAx
MjEwOS44NDAxNTkNCjYgOTY5My41ODUxNDkNCjYgMTIxODAuMzQwMDcyDQo4
IDEwODEwLjIzMTE0OQ0KOCAxMDgzNy4yMzM3NDQNCjggMTA3OTkuNzQ0ODY3
DQo4IDEwODM5LjA5NDQwMg0KOCAxMDgxNi41ODk3OTMNCjEwIDEwNjU1Ljcx
NjU2OA0KMTAgMTA2NDMuNTMyNDUyDQoxMCAxMDYwOS44NDU0MjcNCjEwIDEw
NjE1LjgzNjM0NA0KMTAgMTA2NDUuOTQ1OTY1DQoxNSAxMDI3Ny40OTk2ODcN
CjE1IDEwMjA3Ljg4ODA5Nw0KMTUgMTAxOTMuNDA5NzMwDQoxNSAxMDIxNy4w
ODI2MDcNCjE1IDEwMjA3LjkwMDYwMw0KMjAgOTcxOS4xNjg1MTMNCjIwIDk3
MTUuMTEzOTk3DQoyMCA5NzE4LjIwNTA5NA0KMjAgOTcwMS45MDYwMjcNCjIw
IDk2OTAuMDE4MjU0DQozMCA4ODk5LjE3NzM2Nw0KMzAgODg0NC42NzIxMTMN
CjMwIDg4NjguNTQ5ODkxDQozMCA4ODc5LjcxMzA1Nw0KMzAgODg4NC45MzY0
NzQNCjQwIDgzNjEuMjE5Mzk0DQo0MCA4MzUwLjM2OTQ3OQ0KNDAgODM2My45
MDg5OTcNCjQwIDgzNDguMTMzMTgyDQo0MCA4MzQ0LjgyMjA2Nw0KNTAgODA5
NS4xODY0NDANCjUwIDgwOTUuMDQ5NDgxDQo1MCA4MTMxLjA3ODE4NA0KNTAg
ODA5Ni4wMTgxMjcNCjUwIDgwOTAuODQwNzIzDQo=

---559023410-1804928587-1211383827=:8451
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME=q6600-results-2.6.24.txt
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.64.0805211204152.16929@westnet.com>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=q6600-results-2.6.24.txt

Mi42LjI0LjQgeDg2XzY0DQoxIDExNDIxLjgyMDE1NA0KMSAxMTQzMS42NzAz
OTENCjEgMTE0NDkuNTk0MTkyDQoxIDExNDI3Ljc5OTU2Mg0KMSAxMTQ2OC40
NzY0ODQNCjIgMTQzMjUuODYzNTQyDQoyIDE0NDM3LjE3NDY4NQ0KMiAxNDQw
Mi4zMzgyNDgNCjIgMTQ3OTkuNDM2NTU2DQoyIDE0NzcyLjMxNDMxOQ0KMyAx
OTY2OC44MDU0NzQNCjMgMTk1MzUuMTc1Mzg5DQozIDE5MzU0LjY4NTExOQ0K
MyAxOTI5NS40MjA2NjgNCjMgMTkzMzYuNzI0Mzg0DQo0IDIyMTAzLjU0NTgy
OQ0KNCAyMjYwMi41Mzc1NDINCjQgMjE4NjUuMzMxNDI0DQo0IDIxMTc4LjM2
ODY2OA0KNCAyMjQyNC42NDcwMTkNCjUgMjYyNzAuMzAwMzc1DQo1IDI2NjE0
LjcyMTgyNw0KNSAyNjY3OC44ODkxNTUNCjUgMjcxOTcuODQ0MTkwDQo1IDI1
Nzc0LjA1OTQ0MA0KNiAyNzIzOC4zNjg0MTENCjYgMjc3MzAuMjEwODYxDQo2
IDI3NDg5LjU2ODY2Ng0KNiAyODM0Ny4wODg4MzYNCjYgMjcxMjIuNzM3NDY2
DQo4IDI3NjMyLjI3ODQ4MA0KOCAyODc5Ni4wNzA4MzQNCjggMjkyMzIuODQy
NTE0DQo4IDI4NjgxLjk1MjQyNg0KOCAyODU2Mi44NzYwMzANCjEwIDMxMTg5
LjkxMDY4OA0KMTAgMzA0NTkuODYxNjcwDQoxMCAzMDMzMC4xODA0MTANCjEw
IDMwNzI2LjY0ODM2Mg0KMTAgMTA5MDIuMjc5MTY1DQoxNSAxMDQ0Ny4zODcy
MzQNCjE1IDI1Mjk1LjY1OTk0NA0KMTUgMTAzNzUuMzI0NDMwDQoxNSAxMDM1
NS4yMjE2OTcNCjE1IDExMzE0Ljg2MDU4MA0KMjAgOTg5Ny4yOTg3MDENCjIw
IDk4OTIuNDA0Mjc2DQoyMCA5ODY4LjY3NjUzNA0KMjAgODkxMS42NjMxMzkN
CjIwIDk4NzkuNTMzOTAzDQozMCA5MDE4LjczOTY1OA0KMzAgOTA1Mi43NDYz
MDMNCjMwIDkwMTguNzk0MTYwDQozMCA5MDA5LjMyNDc3Mw0KMzAgOTI3Mi44
NTk5NTUNCjQwIDg1MDEuNzY2MDcyDQo0MCA4NTM4LjA5MTcxNA0KNDAgODQ3
Ni44NDYzNDINCjQwIDg2NjQuMDU2OTk1DQo0MCA4NDkwLjI2NDU1Mw0KNTAg
ODE5Mi44MjYzNjENCjUwIDgyMTguODgwNjI2DQo1MCA4MjI1LjA4NjM5OA0K
NTAgODIyMS4yMjE5MDANCjUwIDgzNDMuNTczNjc5DQoNCg==

---559023410-1804928587-1211383827=:8451
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME=q6600-results-2.6.22.txt
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.64.0805211204153.16929@westnet.com>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=q6600-results-2.6.22.txt

Mi42LjIyLjE5IHg4Nl82NA0KMSA3NjIzLjQ4NDA1MQ0KMSA3NjI1LjkxNTMw
MA0KMSA3NTg5LjQ2ODY0MQ0KMSA3NTcwLjU4NDkxNg0KMSA3NjUyLjMxNTUx
NA0KMiAxNzcwMi44MjQ4MDQNCjIgMTczNjkuNjk5NDYzDQoyIDE3MjIyLjY0
MjI2Mw0KMiAxNzU5My4zNDAxNDcNCjIgMTU2MzcuNTE3MzQ0DQozIDI2Mzc3
LjMyNTYxMw0KMyAxOTI1Ni41MTM5NjYNCjMgMjY4MTMuMjA3Njc1DQozIDI4
Nzc3LjIyODkyNw0KMyAyOTQzMi4wODE3MDINCjQgMjI2NDAuOTM4NzExDQo0
IDI3NTg5LjM1Nzc5MQ0KNCAyMTYwMi4xMzA2NjENCjQgMjAyNzIuNDU3Nzc4
DQo0IDI4OTQ5LjEyMzY1Mg0KNSAyNTgxNS41Mzg2ODMNCjUgMjQ4NzEuODQ3
ODA0DQo1IDI2MjM4LjExNzc0MA0KNSAyNTU3MC40MjUwNDINCjUgMjQ1NTEu
NjM3OTg3DQo2IDIzOTAxLjc4ODQwMw0KNiAyNTEwNS42OTkyMjINCjYgMjYy
MjkuMDA5Mzk2DQo2IDI1NTE3LjYyMDExMQ0KNiAyMTkwOS44NTMxMjQNCjgg
MjM2NzQuOTAzNzk3DQo4IDI1MjMxLjY0NTQyOQ0KOCAyNTI1NS43NDU5OTgN
CjggMjM4NjkuNzgzNjQ3DQo4IDIzODE4LjgwNzQ3Mw0KMTAgMjE3MDMuMzcx
NzcxDQoxMCAyMzgzOS40MDgyMTENCjEwIDIzMTg1LjkxMTEyNw0KMTAgMjM2
NjUuMDkzNDkwDQoxMCAyNDcxNy45MDY4ODgNCjE1IDIzNDIxLjUwMjI0Ng0K
MTUgMjM0MDMuMzQwNTA2DQoxNSAyMzMyOS4wMjU1ODcNCjE1IDIyNzMwLjc2
NTM0OQ0KMTUgMjMyMDcuNzQ3NTIxDQoyMCAyMjQ4MC44ODczMTINCjIwIDIy
NjM1LjE1NzkyMw0KMjAgMjI1MTEuODg1MTUwDQoyMCAyMjIyMy44MzIyMTUN
CjIwIDE2NTUzLjU4MDg3OQ0KMzAgMTk0MDcuMDg5MDcxDQozMCAyMTcxOC4x
MDg5ODANCjMwIDIwNjQ1Ljg4ODYzMQ0KMzAgMjE2NTAuNTM3OTI5DQozMCAy
MTk5My45ODQ5MjMNCjQwIDIwMDk4LjIzMjExOQ0KNDAgMTk1NjIuNjMwNDQ2
DQo0MCAyMDIzNi44ODA3ODQNCjQwIDE5MTgxLjcxMjAwMg0KNDAgMjA4MzUu
NzgxNTM4DQo1MCAxOTA0My45NTE3MjcNCjUwIDE5ODU5LjkwMDMxOQ0KNTAg
MTgxMjIuMjI4OTk4DQo1MCAxOTQ2Ny44ODA1MjgNCjUwIDE5OTIxLjcxNTYy
Ng0KDQo=

---559023410-1804928587-1211383827=:8451
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME=q6600-results-2.6.26-rc2.txt
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.64.0805211326350.13270@westnet.com>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=q6600-results-2.6.26-rc2.txt

Mi42LjI2LXJjMiB4ODZfNjQNCjEgMTEwMjMuMTM5MTEyDQoxIDExMDM5LjE1
MTc4Nw0KMSAxMDk2MS4yMzMyOTcNCjEgMTEwMDYuOTQzODQxDQoxIDExMDM0
LjExNjI3NA0KMiAxMTU4OC4xODUxMDQNCjIgMTE0MTIuMDQ2Nzg1DQoyIDEx
NjM2LjQ0MDgxOA0KMiAxMTUxOS45MTA0OTUNCjIgMTAxMTAuMzUwNDMxDQoz
IDEyODEyLjAwNDI1MQ0KMyAxMzU4MC42MjI2NDgNCjMgMTMzNzkuNTI3MDU4
DQozIDEzMzAzLjYxMjc2NQ0KMyAxMzI1MS45MTI3NjcNCjQgMTMyODEuNjA0
MTQyDQo0IDEzODAwLjgxODU4Mg0KNCAxMjg0Ny42NTEwMTMNCjQgMTI1Nzku
NzY5ODkzDQo0IDEyNjY5LjMxNzUxMA0KNSAxMzA3MC42MzI3ODUNCjUgMTI1
MDMuNTI5MTIxDQo1IDEyNjUzLjUwNDQwNw0KNSAxMjQ0Mi4zODcwODINCjUg
MTE4OTUuMzc4NzE3DQo2IDEyMjU2LjMyMjMwOQ0KNiAxMjIyOC43MDE1MTkN
CjYgMTI2MjguOTU0Njc5DQo2IDEyMjAzLjExNTMxMQ0KNiAxMjYxMC42NDA3
MjkNCjggMTE3NTQuNjg1MzU5DQo4IDExNDIxLjcxOTcwMg0KOCAxMDIzNy4x
ODc0NDMNCjggMTE3MjkuMDQ5NTcyDQo4IDExNTc1LjkzMzcyNg0KMTAgMTE1
ODIuNzYyNDg3DQoxMCAxMTU2Ny40MTYxMTYNCjEwIDExNjEyLjU0NjAwOQ0K
MTAgMTE1ODAuMjk5ODI2DQoxMCAxMTUxMS40MDc1MTcNCjE1IDExMzAxLjAy
NzU0Nw0KMTUgMTEyMTEuMjI4Njc1DQoxNSAxMTI3MC4wMDAxOTMNCjE1IDEx
MTY0LjkwNjUyOQ0KMTUgMTExMjAuMzkwMTUxDQoyMCAxMTIyMi42NTMwNjAN
CjIwIDEwODQ3Ljg4NzEzMA0KMjAgMTEzNDMuNDE5Mjk3DQoyMCAxMTE1OC42
NDk0MzcNCjIwIDExMzA3LjI3MjE4Mg0KMzAgMTAzMDIuODcwODExDQozMCAx
MDA5Mi44NDAyMDANCjMwIDEwNDA0LjgzNjQ4NQ0KMzAgMTAxNTMuMTcwODIy
DQozMCAxMDYzMy4xOTM0MjkNCjQwIDEwMzY4LjI2NjMwNA0KNDAgMTAwMTcu
MDA2ODc0DQo0MCA5NjgyLjAzMTQzNw0KNDAgMTAxNjYuNzcyNjg5DQo0MCAx
MDQxMy42ODI0OTYNCjUwIDk5OTQuNjEwOTA2DQo1MCA5MzMzLjk5NTE3Ng0K
NTAgOTQyNi4xNjA3ODINCjUwIDk4NDUuNzA4ODgxDQo1MCAxMDAxOC4wODE2
MzYNCg==

---559023410-1804928587-1211383827=:8451--
