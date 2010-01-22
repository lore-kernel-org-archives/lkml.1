Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260Ab0AVMNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0AVMNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 07:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982Ab0AVMNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 07:13:10 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:37081 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0AVMNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 07:13:08 -0500
X-Greylist: delayed 860 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jan 2010 07:13:08 EST
From: Kirill Smelkov <kirr@mns.spb.ru>
To: linux-kernel@vger.kernel.org
Cc: Kirill Smelkov <kirr@mns.spb.ru>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@linux.intel.com>, Peter Botha <peterb@goldcircle.co.za>,
       Denis Vlasenko <vda@ilport.com.ua>
Subject: [RFC PATCH] mxser: make /dev/ttyMI<n> namespace contiguous
Date: Fri, 22 Jan 2010 14:56:42 +0300
Message-Id: <1264161402-4669-1-git-send-email-kirr@mns.spb.ru>
X-Mailer: git-send-email 1.6.6.1.394.gdedc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I've been beaten by the difference of how /dev/ttyMI* entries
are created for two cases:

    a) two CP-114 cards (each with 4 ports), and
    b) one CP-118 card (with 8 ports on board)

compare:

    CP114+CP114       CP118

      ttyMI0          ttyMI0
      ttyMI1          ttyMI1
      ttyMI2          ttyMI2
      ttyMI3          ttyMI3
      ttyMI8          ttyMI4
      ttyMI9          ttyMI5
      ttyMI10         ttyMI6
      ttyMI11         ttyMI7

i.e. in case of 8-ports board, we have contigous /dev entries for 8
serial ports, but in case of two 4-ports board, there is a hole between
4th and 5th ports.

As I see it, the reason Moxa did things this way, is for userspace to
have a simple rule to know /dev entry for n'th port on m'th board easily
-- they always reserve 8 /dev entries for each board
(MXSER_PORTS_PER_BOARD) and the rule is 8*m+n.

However in my situation, this creates confusion -- when my system
starts, I'd like to know /dev entries for n'th serial port and bind
programs to appropriate ports and pretune config files for such
programs. Regardles of how those 8 ports are made - with one CP118
card, or with 2 CP114 cards.

Yes, on system startup, one could always create appropriate com-port
mapping, which will contigously enumerate ports, e.g. something like
this:

    cd /dev/
    n=0
    for port in `ls ttyMI* | sort --key=1.6 -n`; do
        ln -s $port com${n}
        n=$(($n+1))
    done

and then use /dev/com<n>, but is it the right way?

Maybe let's teach mxser to create continous /dev entries in the first
place?

The problem is in mxser_ioctl_special though. For MOXA_CHKPORTENABLE,
MOXA_GETMSTATUS and MOXA_ASPP_MOX_EXT the assumed layout is always 8
ports per board, and so userspace could get confused, if say
CHKPORTENABLE reports 1st port on 2nd board is present, but
open("/dev/ttyMI8") fails.

Although are these ioctls ever used? I've downloaded moxa drivers and
tools (driv_linux_smart_v1.14_build_09061611.tgz) and yes, their tools
use special ioctls, but anyway, the tools still use /dev/ttyM instead of
/dev/ttyMI, and e.g. GETMSTATUS is used on /dev/mxser only, so I'd say
this userspace user is ouuuuut of date.

So would be it an ABI breakage to kill these special ioctls, or change
them in some meaningful way to make /dev/ttyMI<n> namespace continous?

I'm not sure on this - that's why the patch is marked as RFC.

Please advice, and thanks beforehand,
Kirill

Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Peter Botha <peterb@goldcircle.co.za>
Cc: Denis Vlasenko <vda@ilport.com.ua>
Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/char/mxser.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 3d92306..21028b5 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1002,13 +1002,27 @@ static int mxser_open(struct tty_struct *tty, struct file *filp)
 {
 	struct mxser_port *info;
 	int line;
+	unsigned int i, nport;
+	struct mxser_board *board=NULL;
 
 	line = tty->index;
 	if (line == MXSER_PORTS)
 		return 0;
 	if (line < 0 || line > MXSER_PORTS)
 		return -ENODEV;
-	info = &mxser_boards[line / MXSER_PORTS_PER_BOARD].ports[line % MXSER_PORTS_PER_BOARD];
+
+	for (nport = 0, i = 0; i < MXSER_BOARDS; i++)
+		if (line < nport + mxser_boards[i].info->nports) {
+			board = &mxser_boards[i];
+			break;
+		}
+		else
+			nport += mxser_boards[i].info->nports;
+
+	if (!board)
+		return -ENODEV;
+
+	info = &board->ports[line - nport];
 	if (!info->ioaddr)
 		return -ENODEV;
 
@@ -2525,13 +2539,15 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
 {
 #ifdef CONFIG_PCI
 	struct mxser_board *brd;
-	unsigned int i, j;
+	unsigned int i, j, nport;
 	unsigned long ioaddress;
 	int retval = -EINVAL;
 
-	for (i = 0; i < MXSER_BOARDS; i++)
+	for (nport = 0, i = 0; i < MXSER_BOARDS; i++)
 		if (mxser_boards[i].info == NULL)
 			break;
+		else
+			nport += mxser_boards[i].info->nports;
 
 	if (i >= MXSER_BOARDS) {
 		dev_err(&pdev->dev, "too many boards found (maximum %d), board "
@@ -2540,7 +2556,7 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
 	}
 
 	brd = &mxser_boards[i];
-	brd->idx = i * MXSER_PORTS_PER_BOARD;
+	brd->idx = nport;
 	dev_info(&pdev->dev, "found MOXA %s board (BusNo=%d, DevNo=%d)\n",
 		mxser_cards[ent->driver_data].name,
 		pdev->bus->number, PCI_SLOT(pdev->devfn));
@@ -2649,7 +2665,7 @@ static struct pci_driver mxser_driver = {
 static int __init mxser_module_init(void)
 {
 	struct mxser_board *brd;
-	unsigned int b, i, m;
+	unsigned int b, i, m, nport;
 	int retval;
 
 	mxvar_sdriver = alloc_tty_driver(MXSER_PORTS + 1);
@@ -2681,7 +2697,7 @@ static int __init mxser_module_init(void)
 	}
 
 	/* Start finding ISA boards here */
-	for (m = 0, b = 0; b < MXSER_BOARDS; b++) {
+	for (nport = 0, m = 0, b = 0; b < MXSER_BOARDS; b++) {
 		if (!ioaddr[b])
 			continue;
 
@@ -2701,10 +2717,11 @@ static int __init mxser_module_init(void)
 			continue;
 		}
 
-		brd->idx = m * MXSER_PORTS_PER_BOARD;
+		brd->idx = nport;
 		for (i = 0; i < brd->info->nports; i++)
 			tty_register_device(mxvar_sdriver, brd->idx + i, NULL);
 
+		nport += brd->info->nports;
 		m++;
 	}
 
-- 
1.6.6.1.394.gdedc0

