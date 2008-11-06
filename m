Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbYKFUeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbYKFUeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYKFUeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:34:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35526 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYKFUeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:34:04 -0500
Date: Thu, 6 Nov 2008 20:33:49 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Lee Howard <lee.howard@mainpine.com>
Cc: "'Peter Alfredsen'" <loki_val@gentoo.org>,
       "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is the PCI serial driver code GPL v2 or v3
Message-ID: <20081106203349.GA18964@flint.arm.linux.org.uk>
References: <20081106174341.GA8155@xolotl.n0ano.com> <200811061952.37490.loki_val@gentoo.org> <20081106191250.GA28514@flint.arm.linux.org.uk> <AA46BE34D4E74CB69F948F36984126A9@callisto> <20081106201501.GB28514@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106201501.GB28514@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 08:15:01PM +0000, Russell King wrote:
> On Thu, Nov 06, 2008 at 11:39:44AM -0800, Lee Howard wrote:
> > The "hack" originates from code done by Oxford Semiconductor.  I would be
> > happy to have it done with the quirk system, and I am willing to write a
> > patch to that effect.  My guess, however, would be that I'll still not do it
> > in your favorite way, and so I'm asking if you would like me to write the
> > code change or will you (or someone else here familiar with the favorite
> > ways) do it?
> 
> There's plenty of examples in there, eg, pci_timedia_init, pci_netmos_init,
> and pci_ite887x_init all have a variable number of ports.  Here's a patch
> which converts it:

And here's a patch (to be applied on top of the last) which prevents
this happening again by making use of 'const'.

diff -u b/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
--- b/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -42,7 +42,8 @@
 	u32	subvendor;
 	u32	subdevice;
 	int	(*init)(struct pci_dev *dev);
-	int	(*setup)(struct serial_private *, struct pciserial_board *,
+	int	(*setup)(struct serial_private *,
+			 const struct pciserial_board *,
 			 struct uart_port *, int);
 	void	(*exit)(struct pci_dev *dev);
 };
@@ -107,7 +108,7 @@
  * ADDI-DATA GmbH communication cards <info@addi-data.com>
  */
 static int addidata_apci7800_setup(struct serial_private *priv,
-				struct pciserial_board *board,
+				const struct pciserial_board *board,
 				struct uart_port *port, int idx)
 {
 	unsigned int bar = 0, offset = board->first_offset;
@@ -134,7 +135,7 @@
  * Not that ugly ;) -- HW
  */
 static int
-afavlab_setup(struct serial_private *priv, struct pciserial_board *board,
+afavlab_setup(struct serial_private *priv, const struct pciserial_board *board,
 	      struct uart_port *port, int idx)
 {
 	unsigned int bar, offset = board->first_offset;
@@ -188,8 +189,9 @@
  * some serial ports are supposed to be hidden on certain models.
  */
 static int
-pci_hp_diva_setup(struct serial_private *priv, struct pciserial_board *board,
-	      struct uart_port *port, int idx)
+pci_hp_diva_setup(struct serial_private *priv,
+		const struct pciserial_board *board,
+		struct uart_port *port, int idx)
 {
 	unsigned int offset = board->first_offset;
 	unsigned int bar = FL_GET_BASE(board->flags);
@@ -306,7 +308,7 @@
 
 /* SBS Technologies Inc. PMC-OCTPRO and P-OCTAL cards */
 static int
-sbs_setup(struct serial_private *priv, struct pciserial_board *board,
+sbs_setup(struct serial_private *priv, const struct pciserial_board *board,
 		struct uart_port *port, int idx)
 {
 	unsigned int bar, offset = board->first_offset;
@@ -463,7 +465,7 @@
 }
 
 static int pci_siig_setup(struct serial_private *priv,
-			  struct pciserial_board *board,
+			  const struct pciserial_board *board,
 			  struct uart_port *port, int idx)
 {
 	unsigned int bar = FL_GET_BASE(board->flags) + idx, offset = 0;
@@ -534,7 +536,8 @@
  * Ugh, this is ugly as all hell --- TYT
  */
 static int
-pci_timedia_setup(struct serial_private *priv, struct pciserial_board *board,
+pci_timedia_setup(struct serial_private *priv,
+		  const struct pciserial_board *board,
 		  struct uart_port *port, int idx)
 {
 	unsigned int bar = 0, offset = board->first_offset;
@@ -568,7 +571,7 @@
  */
 static int
 titan_400l_800l_setup(struct serial_private *priv,
-		      struct pciserial_board *board,
+		      const struct pciserial_board *board,
 		      struct uart_port *port, int idx)
 {
 	unsigned int bar, offset = board->first_offset;
@@ -770,7 +773,8 @@
 }
 
 static int
-pci_default_setup(struct serial_private *priv, struct pciserial_board *board,
+pci_default_setup(struct serial_private *priv,
+		  const struct pciserial_board *board,
 		  struct uart_port *port, int idx)
 {
 	unsigned int bar, offset = board->first_offset, maxnr;
@@ -1099,7 +1103,7 @@
 }
 
 static inline int get_pci_irq(struct pci_dev *dev,
-				struct pciserial_board *board)
+				const struct pciserial_board *board)
 {
 	if (board->flags & FL_NOIRQ)
 		return 0;
@@ -1894,8 +1898,8 @@
 }
 
 static inline int
-serial_pci_matches(struct pciserial_board *board,
-		   struct pciserial_board *guessed)
+serial_pci_matches(const struct pciserial_board *board,
+		   const struct pciserial_board *guessed)
 {
 	return
 	    board->num_ports == guessed->num_ports &&
@@ -1906,7 +1910,7 @@
 }
 
 struct serial_private *
-pciserial_init_ports(struct pci_dev *dev, struct pciserial_board *board)
+pciserial_init_ports(struct pci_dev *dev, const struct pciserial_board *board)
 {
 	struct uart_port serial_port;
 	struct serial_private *priv;
@@ -2039,7 +2043,8 @@
 pciserial_init_one(struct pci_dev *dev, const struct pci_device_id *ent)
 {
 	struct serial_private *priv;
-	struct pciserial_board *board, tmp;
+	const struct pciserial_board *board;
+	struct pciserial_board tmp;
 	int rc;
 
 	if (ent->driver_data >= ARRAY_SIZE(pci_boards)) {
@@ -2066,7 +2071,7 @@
 		 * We matched one of our class entries.  Try to
 		 * determine the parameters of this board.
 		 */
-		rc = serial_pci_guess_board(dev, board);
+		rc = serial_pci_guess_board(dev, &tmp);
 		if (rc)
 			goto disable;
 	} else {
only in patch2:
unchanged:
--- a/include/linux/8250_pci.h
+++ b/include/linux/8250_pci.h
@@ -31,7 +31,7 @@ struct pciserial_board {
 struct serial_private;
 
 struct serial_private *
-pciserial_init_ports(struct pci_dev *dev, struct pciserial_board *board);
+pciserial_init_ports(struct pci_dev *dev, const struct pciserial_board *board);
 void pciserial_remove_ports(struct serial_private *priv);
 void pciserial_suspend_ports(struct serial_private *priv);
 void pciserial_resume_ports(struct serial_private *priv);


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
