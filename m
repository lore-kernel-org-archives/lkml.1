Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZBVQa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZBVQa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 11:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZBVQaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 11:30:16 -0500
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:55765 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZBVQaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 11:30:15 -0500
Message-ID: <49A17D90.1080905@numericable.fr>
Date: Sun, 22 Feb 2009 17:30:08 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SMACK] convert smack rule list to linux list
References: <fa.JI7eCUCI0gjfyTdUdhIf4ZvZn1Q@ifi.uio.no> <fa.VIgNcVDTCE/wNXrAutvWzCWynf0@ifi.uio.no> <fa.JLh+cst3ii911Hjql2Um0CktNnM@ifi.uio.no> <fa.C6JdJ3BhdOO3tiGIAv+XuVpBjBk@ifi.uio.no>
In-Reply-To: <fa.C6JdJ3BhdOO3tiGIAv+XuVpBjBk@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Sun, Feb 22, 2009 at 10:13:49PM +0900, Tetsuo Handa wrote:
>> Paul, would you review this locking?
>>
>>> static DEFINE_MUTEX(smack_known_lock);
>>>
>>> /**
>>>  * smk_import_entry - import a label, return the list entry
>>>  * @string: a text string that might be a Smack label
>>>  * @len: the maximum size, or zero if it is NULL terminated.
>>>  *
>>>  * Returns a pointer to the entry in the label list that
>>>  * matches the passed string, adding it if necessary.
>>>  */
>>> struct smack_known *smk_import_entry(const char *string, int len)
>>> {
>>> 	struct smack_known *skp;
>>> 	char smack[SMK_LABELLEN];
>>> 	int found;
>>> 	int i;
>>>
>>> 	if (len <= 0 || len > SMK_MAXLEN)
>>> 		len = SMK_MAXLEN;
>>>
>>> 	for (i = 0, found = 0; i < SMK_LABELLEN; i++) {
>>> 		if (found)
>>> 			smack[i] = '\0';
>>> 		else if (i >= len || string[i] > '~' || string[i] <= ' ' ||
>>> 			 string[i] == '/') {
>>> 			smack[i] = '\0';
>>> 			found = 1;
>>> 		} else
>>> 			smack[i] = string[i];
>>> 	}
>>>
>>> 	if (smack[0] == '\0')
>>> 		return NULL;
>>>
>>> 	mutex_lock(&smack_known_lock);
>>>
>>> 	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
>>> 		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0)
>>> 			break;
>>>
>>> 	if (skp == NULL) {
>>> 		skp = kzalloc(sizeof(struct smack_known), GFP_KERNEL);
>>> 		if (skp != NULL) {
>>> 			skp->smk_next = smack_known;
>>> 			strncpy(skp->smk_known, smack, SMK_MAXLEN);
>>> 			skp->smk_secid = smack_next_secid++;
>>> 			skp->smk_cipso = NULL;
>>> 			spin_lock_init(&skp->smk_cipsolock);
>>> 			/*
>>> 			 * Make sure that the entry is actually
>>> 			 * filled before putting it on the list.
>>> 			 */
>>> 			smp_mb();
>>> 			smack_known = skp;
> 
> If the read side is not acquiring smack_known_lock, then the above
> assignment to smack_known needs to be:
> 
> 			rcu_assign_pointer(smack_known, skp);
> 
> Otherwise, both CPU and compiler are within their rights to reorder
> the assignment to smack_known ahead of the initialization code.
> 
> Alternatively, if you make this list use a standard struct list_head,
> you could just use list_add_rcu().
>
that's what i was going to do ;)

 
>>> 		}
>>> 	}
>>>
>>> 	mutex_unlock(&smack_known_lock);
>>>
>>> 	return skp;
>>> }
>>>
>>> /**
>>>  * smack_from_secid - find the Smack label associated with a secid
>>>  * @secid: an integer that might be associated with a Smack label
>>>  *
>>>  * Returns a pointer to the appropraite Smack label if there is one,
>>>  * otherwise a pointer to the invalid Smack label.
>>>  */
>>> char *smack_from_secid(const u32 secid)
>>> {
>>> 	struct smack_known *skp;
>>>
>>> 	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
>>> 		if (skp->smk_secid == secid)
>>> 			return skp->smk_known;
>>>
>>> 	/*
>>> 	 * If we got this far someone asked for the translation
>>> 	 * of a secid that is not on the list.
>>> 	 */
>>> 	return smack_known_invalid.smk_known;
>>> }
>> I think this is a case called "dependency ordering".
>> This function needs rcu_dereference(), doesn't it?
> 
> Indeed!  The "for" loop needs to be:
> 
> 	for (skp = rcu_dereference(smack_known); skp != NULL; skp = rcu_dereference(skp->smk_next))
> 
> Alternatively, if you switch to struct list_head, you could use
> list_for_each_entry_rcu().
> 
> There also need to be rcu_read_lock() and rcu_read_unlock() in here
> somewhere.  Where they must be depends on how (or whether) you are
> ever removing any elements.  If the string referenced by smk_known
> gets freed up, then the caller will need to surround the call to
> smack_from_secid() and the use of the return value with rcu_read_lock()
> and rcu_read_unlock().  Otherwise, only the smack_known structures are
> ever freed up, then just the "for" loop above needs to be so protected.
> 
> If these structure are never freed, then please add a comment.
> 

for the time being there are not freed; but if think it's safer to add the 
"rcu_read_lock()/rcu_read_unlock()" anyway (in case someone want to implement a del in the future)
I don't think they are any downside?

thanks for the explanations!



