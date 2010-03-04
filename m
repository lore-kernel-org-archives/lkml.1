Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0CDKKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:10:25 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51089 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab0CDKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:10:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 04 Mar 2010 02:08:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/12] genericirq: make irq_chip to have member with irq_desc
 pointer
In-reply-to: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1267697339-5491-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will have
void            (*desc_ack)(struct irq_desc *desc);
void            (*desc_mask)(struct irq_desc *desc);
void            (*desc_mask_ack)(struct irq_desc *desc);
void            (*desc_unmask)(struct irq_desc *desc);
void            (*desc_eoi)(struct irq_desc *desc);

so for sparseirq with raidix tree, we don't call extra irq_to_desc, and could use desc directly

-v2: change all member of irq_chip to use desc only.
-v3: update after legacy_pic
     according to Thomas, use other copy for new member with *desc, so could
     make the transition more smooth

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/irq.h |  129 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 129 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 707ab12..b686d1e 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -110,6 +110,7 @@ struct msi_desc;
  */
 struct irq_chip {
 	const char	*name;
+
 	unsigned int	(*startup)(unsigned int irq);
 	void		(*shutdown)(unsigned int irq);
 	void		(*enable)(unsigned int irq);
@@ -135,6 +136,34 @@ struct irq_chip {
 #ifdef CONFIG_IRQ_RELEASE_METHOD
 	void		(*release)(unsigned int irq, void *dev_id);
 #endif
+
+	unsigned int	(*desc_startup)(struct irq_desc *desc);
+	void		(*desc_shutdown)(struct irq_desc *desc);
+	void		(*desc_enable)(struct irq_desc *desc);
+	void		(*desc_disable)(struct irq_desc *desc);
+
+	void		(*desc_ack)(struct irq_desc *desc);
+	void		(*desc_mask)(struct irq_desc *desc);
+	void		(*desc_mask_ack)(struct irq_desc *desc);
+	void		(*desc_unmask)(struct irq_desc *desc);
+	void		(*desc_eoi)(struct irq_desc *desc);
+
+	void		(*desc_end)(struct irq_desc *desc);
+	int		(*desc_set_affinity)(struct irq_desc *desc,
+					const struct cpumask *dest);
+	int		(*desc_retrigger)(struct irq_desc *desc);
+
+	int		(*desc_set_type)(struct irq_desc *desc, unsigned int flow_type);
+	int		(*desc_set_wake)(struct irq_desc *desc, unsigned int on);
+
+	void		(*desc_bus_lock)(struct irq_desc *desc);
+	void		(*desc_bus_sync_unlock)(struct irq_desc *desc);
+
+	/* Currently used only by UML, might disappear one day.*/
+#ifdef CONFIG_IRQ_RELEASE_METHOD
+	void		(*desc_release)(struct irq_desc *desc, void *dev_id);
+#endif
+
 	/*
 	 * For compatibility, ->typename is copied into ->name.
 	 * Will disappear.
@@ -227,6 +256,106 @@ static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
 
 extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
 
+static inline unsigned int
+desc_chip_startup(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_startup)
+		return chip->desc_startup(desc);
+	else if (chip->startup)
+		return chip->startup(irq);
+	return 0;
+}
+static inline void
+desc_chip_shutdown(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_shutdown)
+		chip->desc_shutdown(desc);
+	else if (chip->shutdown)
+		chip->shutdown(irq);
+}
+static inline void
+desc_chip_enable(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_enable)
+		chip->desc_enable(desc);
+	else if (chip->enable)
+		chip->enable(irq);
+}
+static inline void
+desc_chip_disable(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_disable)
+		chip->desc_disable(desc);
+	else if (chip->disable)
+		chip->disable(irq);
+}
+static inline void
+desc_chip_ack(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_ack)
+		chip->desc_ack(desc);
+	else if (chip->ack)
+		chip->ack(irq);
+}
+static inline void
+desc_chip_mask(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_mask)
+		chip->desc_mask(desc);
+	else if (chip->mask)
+		chip->mask(irq);
+}
+static inline void
+desc_chip_mask_ack(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_mask_ack)
+		chip->desc_mask_ack(desc);
+	else if (chip->mask_ack)
+		chip->mask_ack(irq);
+}
+static inline void
+desc_chip_unmask(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_unmask)
+		chip->desc_unmask(desc);
+	else if (chip->unmask)
+		chip->unmask(irq);
+}
+static inline void
+desc_chip_eoi(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_eoi)
+		chip->desc_eoi(desc);
+	else if (chip->eoi)
+		chip->eoi(irq);
+}
+static inline void
+desc_chip_end(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_end)
+		chip->desc_end(desc);
+	else if (chip->end)
+		chip->end(irq);
+}
+static inline int
+desc_chip_set_affinity(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc, const struct cpumask *dest)
+{
+	if (chip->desc_set_affinity)
+		return chip->desc_set_affinity(desc, dest);
+	else if (chip->set_affinity)
+		return chip->set_affinity(irq, dest);
+	return 0;
+}
+static inline int
+desc_chip_retrigger(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_retrigger)
+		return chip->desc_retrigger(desc);
+	else if (chip->startup)
+		return chip->retrigger(irq);
+	return 0;
+}
+
 /*
  * Pick up the arch-dependent methods:
  */
-- 
1.6.4.2

