Return-Path: <linux-kernel-owner+w=401wt.eu-S933405AbXHLLQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405AbXHLLQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 07:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXHLLQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 07:16:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37894 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbXHLLQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 07:16:33 -0400
Date: Sun, 12 Aug 2007 13:16:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
In-Reply-To: <228687.90899.qm@web36605.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0708121309530.28963@fbirervta.pbzchgretzou.qr>
References: <228687.90899.qm@web36605.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 11 2007 16:22, Casey Schaufler wrote:
>> >@@ -0,0 +1,8 @@
>> >+#
>> >+# Makefile for the SMACK LSM
>> >+#
>> >+
>> >+obj-$(CONFIG_SECURITY_SMACK) := smack.o
>> >+
>> >+smack-y := smack_lsm.o smack_access.o smackfs.o
>> 
>> smack-objs :=
>
>Added.

I should have added "replace it".

>> >+/*
>> >+ * 'ssssssss oooooooo mmmm\n\0' 
>> >+ */
>> 
>> I wonder why it's limited to 8 characters? Ah right.. sizeof(smack_t).
>> uhm.. are you trying to tell me that smack_t [typedef'ed to u64]
>> are actually meant as a char[8]? (/me scrathces head)
>
>Yes. "s == o" vs "strcmp(s,o) == 0".

Evil optimization ;-)
[ s == o is memcmp(s, o, sizeof(that)) == 0]

>> >+	char temp[80];
>> >+	ssize_t rc;
>> >+
>> >+	if (*ppos != 0)
>> >+		return 0;
>> >+
>> >+	sprintf(temp, "%d", smk_cipso_doi_value);
>> >+	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
>> 
>> 80 is plenty for a 11 char string.
>> 
>> Look, they've got funny ideas! :)
>> net/ipv4/netfilter/nf_nat_irc.c:char buffer[sizeof("4294967296 65635")];

Proposal would have been: char temp[sizeof("4294967296")];

>> >+extern int smack_net_nltype;
>> >+extern int smack_cipso_direct;
>> >+extern struct smk_cipso_entry *smack_cipso;
>> 
>> for consistency reasons, add extern to the other vars too...
>
>the others?

There were some [or some function prototypes] above this point.

>> >+static int smack_task_movememory(struct task_struct *p)
>> >+{
>> >+	int rc;
>> >+
>> >+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
>> >+	return rc;
>> >+}
>> 
>> Uh...
>> 
>> {
>> 	return smk_curacc(smk_of_task(p), MAY_WRITE);
>> }
>> 
>> (also others)
>
>That was a little excessive, wasn't it?

How do you mean? I was just suggesting to collapse the three [four] lines into
one, getting rid of the tempotemporaries in a lot of these functions,
for example,

>> >+static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>> >+			   int sig, u32 secid)
>> >+{
>> >+	smack_t *tsp = smk_of_task(p);
>> >+	int rc;
>> >+
>> >+	/*
>> >+	 * Sending a signal requires that the sender
>> >+	 * can write the receiver.
>> >+	 */
>> >+	rc = smk_curacc(tsp, MAY_WRITE);
>> >+
>> >+	return rc;
>> >+}

static int smack_task_kill(struct stask_struct *p, struct siginfo *info,
    int sig, u32 secid)
{
	/* Comment */
	return smk_curacc(smk_of_task(p), MAY_WRITE);
}



	Jan
-- 
