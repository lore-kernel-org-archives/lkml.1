Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZBVRy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZBVRy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZBVRyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:54:19 -0500
Received: from smtp109.prem.mail.sp1.yahoo.com ([98.136.44.54]:39341 "HELO
	smtp109.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751344AbZBVRyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:54:18 -0500
X-YMail-OSG: TMldMz8VM1njaWsN5tcJG5GBq6RdyXTsEtWKb7WDqnDP0cXUWzAsB6Jj90Ay4Uazcst4mIxr6qnIiV.gcFx1GoHyYBFbI6fzRcIEwfLzgNbYKqRo8ckbsxnV7R9vrUPrkE9GokrPnA8QMNILTWkagl3e3.z69577pCsJN7uDjQiOu57EZCW.mlTf6.70wAaJIIiBGfuNNyQrNzhlH8aviGsDmpaCsNisLpbanMZWpUE.nU3wAcb9XFKD.l4-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49A19138.5040603@schaufler-ca.com>
Date: Sun, 22 Feb 2009 09:54:00 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: etienne <etienne.basset@numericable.fr>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, paul.moore@hp.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH][SMACK] convert smack rule list to linux list
References: <49A13E15.6020509@numericable.fr> <200902222040.CAB86425.VMOQHFFFtOSLOJ@I-love.SAKURA.ne.jp> <49A14FBE.7020206@numericable.fr> <20090222153104.GF6860@linux.vnet.ibm.com>
In-Reply-To: <20090222153104.GF6860@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Sun, Feb 22, 2009 at 02:14:38PM +0100, etienne wrote:
>   
>> Tetsuo Handa wrote:
>>     
>>> etienne wrote:
>>>       
>>>> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
>>>> index 2e0b83e..3dc312d 100644
>>>> --- a/security/smack/smack_access.c
>>>> +++ b/security/smack/smack_access.c
>>>> @@ -87,7 +87,6 @@ static u32 smack_next_secid = 10;
>>>>  int smk_access(char *subject_label, char *object_label, int request)
>>>>  {
>>>>  	u32 may = MAY_NOT;
>>>> -	struct smk_list_entry *sp;
>>>>  	struct smack_rule *srp;
>>>>  
>>>>  	/*
>>>> @@ -139,8 +138,8 @@ int smk_access(char *subject_label, char *object_label, int request)
>>>>  	 * access (e.g. read is included in readwrite) it's
>>>>  	 * good.
>>>>  	 */
>>>> -	for (sp = smack_list; sp != NULL; sp = sp->smk_next) {
>>>> -		srp = &sp->smk_rule;
>>>> +
>>>> +	list_for_each_entry(srp, &smack_rule_list, list) {
>>>>  
>>>>  		if (srp->smk_subject == subject_label ||
>>>>  		    strcmp(srp->smk_subject, subject_label) == 0) {
>>>>         
>>> Use of standard doubly linked list requires a lock, doesn't it?
>>> What lock protects smack_rule_list?
>>>
>>>       
>> you're right; 
>>
>> what's the best way, using a rcu variant for "list_for_each, container_of ...etc" ?
>> (concurrent list insertion are already protected with a mutex, so rcu must the good idea for the read side) 
>>     
>
> You want list_for_each_entry_rcu() above.  You will need list_add_rcu()
> when adding elements to the list.
>
> Again, if these elements are ever removed, you will need rcu_read_lock()
> and rcu_read_unlock() surrounding their use.  Otherwise, an element can
> be freed out from under a reader who is still referencing it.
>
> 							Thanx, Paul
>   

You'll also need to be very careful that the locking is safe to use
in the networking hooks, in particular smack_socket_sock_rcv_skb. The
amount of care required to get the locking correct is a major factor
in the current list implementation.

