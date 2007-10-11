Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbXJKTB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbXJKTB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 15:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXJKTBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 15:01:19 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:39102 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754164AbXJKTBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 15:01:18 -0400
Date: Thu, 11 Oct 2007 15:01:17 -0400
To: Chris Bergeron <chris@pcburn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Message-ID: <20071011190117.GH4003@csclub.uwaterloo.ca>
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470E5714.4040303@pcburn.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 01:02:12PM -0400, Chris Bergeron wrote:
> I'm sure that's what it says on the largest chip on the PCI card.  It 
> could be that the other two chips are more relevant... the numbers from 
> them are included below.
> 
> I've posted up a quick text only page with the diagnostic information 
> from the system (full dmesg, lspci, etc) plus links to pictures of the 
> board (since others might see something important that I'm not aware 
> of).  You can access that at 
> http://pcburn.com/files/Syba_serial_controller/index.html
> 
> One chip has "ITE IT8871F 0641-AYS ZF1M04L" written on it, and the other 
> two have  a stylized celtic knot looking "T" followed by "TG16C554CJG 
> FTA6M-001 0620-B".

Well TG16C554 sounds awfully similar to 16550 which is a common UART
type.  Perhaps 554 indicates it is 4 16550s in one chip.  There are two
of those chips in one of the pictures.

Here is a data sheet for it:
http://www.twistsemi.com/downloads/TG16C554V1.5.pdf

It is in fact a quad UART chip.  It appears to have 4 chip select lines
to pick between the 4 UARTS, 3 address lines to access the 8 16550
registers, and 8 data lines to read and write those registers as well as
a pair of read and write enable lines.  They are NOT PCI chips, so quite
likely the IT8871 is there as a PCI to parallel convertor and then the
parallel interface connects to the UARTs.  No idea where the IRQ line
from the chips would connect to (one of the parallel port signals that
generates an IRQ?)

The 8 small chips are probably RS232 level convertors.

The 8871 is a single PCI parallel port, so certainly somehow they are
controlling the two serial to parallel chips through that pci parallel
port.

I included the diff of the files you had on your web page and the
originals founds in 2.4.20 (which is what they claim they replace).

I can't really tell if there is any code there to deal with their quad
uart chip or not.

--- drivers/char/serial.c	2002-11-28 18:53:12.000000000 -0500
+++ /tmp/serial_20.c	2006-11-23 03:17:24.000000000 -0500
@@ -257,6 +257,13 @@
 
 static struct timer_list serial_timer;
 
+//struct pci_dev *pcidev = NULL;
+// ITE8872 ITE8872
+u32 ITE8872_INTC[8];
+int ITEBOARDNUMBER=0;
+u8 ITE8872_IRQ[8];
+
+
 /* serial subtype definitions */
 #ifndef SERIAL_TYPE_NORMAL
 #define SERIAL_TYPE_NORMAL	1
@@ -4165,6 +4172,163 @@
 }
 EXPORT_SYMBOL(pci_siig20x_fn);
 
+void ite8872_requestirq(int irq,void *dev_id,struct pt_regs *regs){
+	u8 itmp;
+	int i=0;
+	/* measure which INTC went to control */
+	for(i=0;i<8;i++)
+	  if(irq == ITE8872_IRQ[i])
+	 {
+	/* clean ITE8872 interrupt */
+	itmp = inb(ITE8872_INTC[i]+2);
+	if(itmp & 0x0f)
+	{
+	outb(itmp,ITE8872_INTC[i]+2);
+	break;
+	}
+	 }
+}
+
+
+/*
+Integrated Technology Express, Inc.
+IT887x Device Driver
+*/
+static int __devinit
+pci_ite8872_fn(struct pci_dev *pcidev, struct pci_board *board, int enable)
+{
+	int result,ite8872comnum=0,ite8872parportnum=0;
+	short INTA_Addr[8]={ 0x2a0,0x2c0,0x220,0x240,0x1E0,0x200,0x280};
+	u32 j=0,u32Tmp,itmp,ITE8872_COM1,ITE8872_COM2,ITE8872SET=0x64E00000,set60,set78,intc;
+       	u32 ite8872_lpt, ite8872_lpthi;
+	
+	printk(KERN_INFO "ITE8872 serial init\n");
+	if (!enable) return 0;
+
+	pci_read_config_dword(pcidev, 0x60,&set60);
+	pci_read_config_dword(pcidev, 0x78,&set78);
+
+	for(j=0; j<7; j++)
+       		if(check_region(INTA_Addr[j], 0x8) >=0){
+		pci_write_config_dword(pcidev, 0x60,0xE7000000|INTA_Addr[j]);
+			pci_write_config_dword(pcidev, 0x78,0x00000000|INTA_Addr[j]);
+        		itmp = inb( INTA_Addr[j]);
+        		if( itmp != 0xFF ) break;
+        	}
+  	       	
+	if( j>=7 ){
+       		printk(KERN_INFO "ITE8872 INTA cannot find.\n");
+       		return 0;
+       	}
+
+	itmp = INTA_Addr[j];
+	u32Tmp = inb(itmp+0x18);
+	u32Tmp &= 0x0F;
+	intc= INTA_Addr[j];
+	switch(u32Tmp){
+		case 0x2:
+			printk(KERN_INFO "ITE887x: ITE8871 found , Parallel*1 \n");
+			ITE8872SET = 0x64200000;
+			ite8872parportnum=1;
+			request_region(intc,0x8,"ite8871");
+			break;
+		case 0xA:
+			printk(KERN_INFO "ITE887x: ITE8875 found , Parallel*1 \n");
+			ITE8872SET = 0x64200000;
+			ite8872parportnum=1;
+			request_region(intc,0x8,"ite8875");
+			break;
+		case 0xE:
+			printk(KERN_INFO "ITE887x: ITE8872 found , Serial *2 , Parallel*1 \n");
+			ite8872comnum = 2;
+			ite8872parportnum=1;
+			ITE8872SET=0x64E00000;
+			request_region(intc,0x8,"ite8872");
+			break;
+		case 0x6:
+			printk(KERN_INFO "ITE887x: ITE8873 found , Serial *1 \n");
+			ite8872comnum = 1;
+			ITE8872SET=0x64800000;
+			request_region(intc,0x8,"ite8873");
+			break;
+		case 0x8:
+			printk(KERN_INFO "ITE887x: ITE8874 found , Serial *2 \n");
+			ite8872comnum = 2;
+			ITE8872SET=0x64C00000;
+			request_region(intc,0x8,"ite8874");
+			break;
+		default:
+			printk(KERN_INFO "ITE887x: unknow ITE887x \n");
+			printk(KERN_INFO "ITE887x: please mail lspci -nvv output to ted.wen@ite.com.tw\n");
+			pci_write_config_dword(pcidev, 0x60,set60);
+			pci_write_config_dword(pcidev, 0x78,set78);
+			return 0;
+			break;
+	}
+
+//	pci_read_config_dword(pcidev, 0x3c,&ITE8872_IRQ[ITEBOARDNUMBER]);
+	ITE8872_IRQ[ITEBOARDNUMBER]=pcidev->irq;
+	
+	printk(KERN_INFO "ITE887X_IRQ : %d \n", ITE8872_IRQ[ITEBOARDNUMBER]);
+	if (ite8872comnum>=1) {
+	result = request_irq(ITE8872_IRQ[ITEBOARDNUMBER],ite8872_requestirq,SA_SHIRQ,"ite8872",&ITE8872_IRQ[ITEBOARDNUMBER]);
+	if(result){
+	printk(KERN_INFO "ITE887x: can't get assign irq :%x \n",ITE8872_IRQ[ITEBOARDNUMBER]);
+		return 0;
+	 }
+	}
+
+
+	//INTC
+	pci_read_config_dword( pcidev, 0x10, &ITE8872_INTC[ITEBOARDNUMBER]);
+	ITE8872_INTC[ITEBOARDNUMBER] &= 0x0000FF00;
+	pci_write_config_dword( pcidev, 0x60, 0xE5000000|ITE8872_INTC[ITEBOARDNUMBER] );
+	pci_write_config_dword( pcidev, 0x78, ITE8872_INTC[ITEBOARDNUMBER] );
+
+	if (ite8872parportnum>=1)
+	{
+	//parport
+	pci_read_config_dword (pcidev, 0x1c, &ite8872_lpt);
+	ite8872_lpt &= 0x0000ff00;
+	pci_read_config_dword (pcidev, 0x20, &ite8872_lpthi);
+	ite8872_lpthi &= 0x0000ff00;
+	pci_write_config_dword (pcidev, 0x6c, 0xe3000000 | ite8872_lpt);
+	pci_write_config_dword (pcidev, 0x70, 0xe3000000 | ite8872_lpthi);
+	pci_write_config_dword (pcidev, 0x80, (ite8872_lpthi<<16) | ite8872_lpt);
+	// SET SPP&EPP , Parallel Port NO DMA , Enable All Function
+	// SET Parallel IRQ
+	printk (KERN_INFO "ITE887x: The PARALLEL I/O port is 0x%x.\n",
+		 ite8872_lpt);
+	printk (KERN_INFO "ITE887x: The PARALLEL I/O porthi is 0x%x.\n",
+		 ite8872_lpthi);
+	}
+	
+	if (ite8872comnum>=1){
+	//COM1
+	pci_read_config_dword( pcidev, 0x14,&ITE8872_COM1);
+	ITE8872_COM1 &= 0x0000FF00;
+	pci_write_config_dword( pcidev, 0x64, 0xE3000000|ITE8872_COM1);
+
+	//COM2
+	if(ite8872comnum == 2){
+	pci_read_config_dword( pcidev, 0x18,&ITE8872_COM2);
+	ITE8872_COM2 &= 0x0000FF00;
+	pci_write_config_dword( pcidev, 0x68, 0xE3000000|ITE8872_COM2);
+	}
+	else	ITE8872_COM2 = 0;
+	
+	pci_write_config_dword( pcidev, 0x7C, (ITE8872_COM2<<16)|(ITE8872_COM1) );
+	}
+	
+	// 9C write enable UART , IRQ Function
+	pci_write_config_dword( pcidev, 0x9c,ITE8872SET|(0x11111*ITE8872_IRQ[ITEBOARDNUMBER]));
+	// Add next interface
+	ITEBOARDNUMBER++;
+       return 0;
+
+}
+
+
 /* Added for EKF Intel i960 serial boards */
 static int __devinit
 pci_inteli960ni_fn(struct pci_dev *dev,
@@ -4348,6 +4512,9 @@
 #ifdef CONFIG_DDB5074
 	pbn_nec_nile4,
 #endif
+#if 1
+        pbn_ite_8872,
+#endif
 #if 0
 	pbn_dci_pccom8,
 #endif
@@ -4444,6 +4611,10 @@
 	{ SPCI_FL_BASE0, 1, 520833,			   /* pbn_nec_nile4 */
 		64, 3, NULL, 0x300 },
 #endif
+#if 1   /* PCI_DEVCE_ID_ITE_8872 */
+        {SPCI_FL_BASE1| SPCI_FL_BASE_TABLE, 2, 115200,
+		0, 0, pci_ite8872_fn, 0},
+#endif
 #if 0	/* PCI_DEVICE_ID_DCI_PCCOM8 ? */		   /* pbn_dci_pccom8 */
 	{ SPCI_FL_BASE3, 8, 115200, 8 },
 #endif
@@ -4906,7 +5077,11 @@
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_nec_nile4 },
 #endif
-
+#if 1	/* ITE 8872 Serial Simple Board */
+	{	PCI_VENDOR_ID_ITE, PCI_DEVICE_ID_ITE_8872,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_ite_8872 },
+#endif
 #if 0	/* PCI_DEVICE_ID_DCI_PCCOM8 ? */
 	{	PCI_VENDOR_ID_DCI, PCI_DEVICE_ID_DCI_PCCOM8,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
--- drivers/parport/parport_pc.c	2002-11-28 18:53:14.000000000 -0500
+++ /tmp/parport_pc_20.c	2006-11-23 03:17:24.000000000 -0500
@@ -253,6 +253,9 @@
 	return !(r & 0x01);
 }
 
+
+
+
 /*
  * Access functions.
  *
@@ -2440,82 +2443,29 @@
 static int __devinit sio_ite_8872_probe (struct pci_dev *pdev, int autoirq,
 					 int autodma)
 {
-	short inta_addr[6] = { 0x2A0, 0x2C0, 0x220, 0x240, 0x1E0 };
-	u32 ite8872set;
-	u32 ite8872_lpt, ite8872_lpthi;
-	u8 ite8872_irq, type;
+	u32 ite8872_lpt, ite8872_lpthi,test;
+	u8  ITE8872_IRQ;
 	int irq;
-	int i;
 
-	DPRINTK (KERN_DEBUG "sio_ite_8872_probe()\n");
+	pci_read_config_dword (pdev, 0x6c, &test);
+	if (test ==0 ) return 0;
 	
-	// make sure which one chip
-	for(i = 0; i < 5; i++) {
-		if (check_region (inta_addr[i], 0x8) >= 0) {
-			int test;
-			pci_write_config_dword (pdev, 0x60,
-						0xe7000000 | inta_addr[i]);
-			pci_write_config_dword (pdev, 0x78,
-						0x00000000 | inta_addr[i]);
-			test = inb (inta_addr[i]);
-			if (test != 0xff) break;
-		}
-	}
-	if(i >= 5) {
-		printk (KERN_INFO "parport_pc: cannot find ITE8872 INTA\n");
-		return 0;
-	}
-
-	type = inb (inta_addr[i] + 0x18);
-	type &= 0x0f;
-
-	switch (type) {
-	case 0x2:
-		printk (KERN_INFO "parport_pc: ITE8871 found (1P)\n");
-		ite8872set = 0x64200000;
-		break;
-	case 0xa:
-		printk (KERN_INFO "parport_pc: ITE8875 found (1P)\n");
-		ite8872set = 0x64200000;
-		break;
-	case 0xe:
-		printk (KERN_INFO "parport_pc: ITE8872 found (2S1P)\n");
-		ite8872set = 0x64e00000;
-		break;
-	case 0x6:
-		printk (KERN_INFO "parport_pc: ITE8873 found (1S)\n");
-		return 0;
-	case 0x8:
-		DPRINTK (KERN_DEBUG "parport_pc: ITE8874 found (2S)\n");
-		return 0;
-	default:
-		printk (KERN_INFO "parport_pc: unknown ITE887x\n");
-		printk (KERN_INFO "parport_pc: please mail 'lspci -nvv' "
-			"output to Rich.Liu@ite.com.tw\n");
-		return 0;
-	}
-
-	pci_read_config_byte (pdev, 0x3c, &ite8872_irq);
+//	pci_read_config_byte (pdev, 0x3c, &ITE8872_IRQ);
+	ITE8872_IRQ=pdev->irq;
 	pci_read_config_dword (pdev, 0x1c, &ite8872_lpt);
 	ite8872_lpt &= 0x0000ff00;
 	pci_read_config_dword (pdev, 0x20, &ite8872_lpthi);
 	ite8872_lpthi &= 0x0000ff00;
-	pci_write_config_dword (pdev, 0x6c, 0xe3000000 | ite8872_lpt);
-	pci_write_config_dword (pdev, 0x70, 0xe3000000 | ite8872_lpthi);
-	pci_write_config_dword (pdev, 0x80, (ite8872_lpthi<<16) | ite8872_lpt);
-	// SET SPP&EPP , Parallel Port NO DMA , Enable All Function
-	// SET Parallel IRQ
-	pci_write_config_dword (pdev, 0x9c,
-				ite8872set | (ite8872_irq * 0x11111));
-
-	DPRINTK (KERN_DEBUG "ITE887x: The IRQ is %d.\n", ite8872_irq);
-	DPRINTK (KERN_DEBUG "ITE887x: The PARALLEL I/O port is 0x%x.\n",
+	
+	printk (KERN_INFO "ITE887x: The IRQ is %d.\n", ITE8872_IRQ);
+	printk (KERN_INFO "ITE887x: The PARALLEL I/O port is 0x%x.\n",
 		 ite8872_lpt);
-	DPRINTK (KERN_DEBUG "ITE887x: The PARALLEL I/O porthi is 0x%x.\n",
+	printk (KERN_INFO "ITE887x: The PARALLEL I/O porthi is 0x%x.\n",
 		 ite8872_lpthi);
 
+
 	/* Let the user (or defaults) steer us away from interrupts */
-	irq = ite8872_irq;
+	irq = ITE8872_IRQ;
 	if (autoirq != PARPORT_IRQ_AUTO)
 		irq = PARPORT_IRQ_NONE;
 
@@ -2525,7 +2475,7 @@
 			"parport_pc: ITE 8872 parallel port: io=0x%X",
 			ite8872_lpt);
 		if (irq != PARPORT_IRQ_NONE)
-			printk (", irq=%d", irq);
+			printk (KERN_INFO " irq=%d", irq);
 		printk ("\n");
 		return 1;
 	}

--
Len Sorensen
