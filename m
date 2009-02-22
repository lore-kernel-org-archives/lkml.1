Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZBVNOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZBVNOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 08:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbZBVNNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 08:13:52 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55109 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZBVNNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 08:13:52 -0500
To: paulmck@linux.vnet.ibm.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SMACK] convert smack rule list to linux list
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <49A13E15.6020509@numericable.fr>
	<200902222040.CAB86425.VMOQHFFFtOSLOJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200902222040.CAB86425.VMOQHFFFtOSLOJ@I-love.SAKURA.ne.jp>
Message-Id: <200902222213.DAE48955.FFSLFtJOVQOHMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 22 Feb 2009 22:13:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul, would you review this locking?

> static DEFINE_MUTEX(smack_known_lock);
> 
> /**
>  * smk_import_entry - import a label, return the list entry
>  * @string: a text string that might be a Smack label
>  * @len: the maximum size, or zero if it is NULL terminated.
>  *
>  * Returns a pointer to the entry in the label list that
>  * matches the passed string, adding it if necessary.
>  */
> struct smack_known *smk_import_entry(const char *string, int len)
> {
> 	struct smack_known *skp;
> 	char smack[SMK_LABELLEN];
> 	int found;
> 	int i;
> 
> 	if (len <= 0 || len > SMK_MAXLEN)
> 		len = SMK_MAXLEN;
> 
> 	for (i = 0, found = 0; i < SMK_LABELLEN; i++) {
> 		if (found)
> 			smack[i] = '\0';
> 		else if (i >= len || string[i] > '~' || string[i] <= ' ' ||
> 			 string[i] == '/') {
> 			smack[i] = '\0';
> 			found = 1;
> 		} else
> 			smack[i] = string[i];
> 	}
> 
> 	if (smack[0] == '\0')
> 		return NULL;
> 
> 	mutex_lock(&smack_known_lock);
> 
> 	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
> 		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0)
> 			break;
> 
> 	if (skp == NULL) {
> 		skp = kzalloc(sizeof(struct smack_known), GFP_KERNEL);
> 		if (skp != NULL) {
> 			skp->smk_next = smack_known;
> 			strncpy(skp->smk_known, smack, SMK_MAXLEN);
> 			skp->smk_secid = smack_next_secid++;
> 			skp->smk_cipso = NULL;
> 			spin_lock_init(&skp->smk_cipsolock);
> 			/*
> 			 * Make sure that the entry is actually
> 			 * filled before putting it on the list.
> 			 */
> 			smp_mb();
> 			smack_known = skp;
> 		}
> 	}
> 
> 	mutex_unlock(&smack_known_lock);
> 
> 	return skp;
> }
> 
> /**
>  * smack_from_secid - find the Smack label associated with a secid
>  * @secid: an integer that might be associated with a Smack label
>  *
>  * Returns a pointer to the appropraite Smack label if there is one,
>  * otherwise a pointer to the invalid Smack label.
>  */
> char *smack_from_secid(const u32 secid)
> {
> 	struct smack_known *skp;
> 
> 	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
> 		if (skp->smk_secid == secid)
> 			return skp->smk_known;
> 
> 	/*
> 	 * If we got this far someone asked for the translation
> 	 * of a secid that is not on the list.
> 	 */
> 	return smack_known_invalid.smk_known;
> }

I think this is a case called "dependency ordering".
This function needs rcu_dereference(), doesn't it?

Regards.
