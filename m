Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbYJ1FwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbYJ1FwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbYJ1FwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:52:04 -0400
Received: from smtp109.prem.mail.sp1.yahoo.com ([98.136.44.54]:43226 "HELO
	smtp109.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752228AbYJ1FwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:52:03 -0400
X-YMail-OSG: JjOa5PQVM1n1UnKp2xFhvjyrAbRtbYPIh4gDYTlyMEO_KFEyx.3O7lUoQ3dv03rAWP7Wax.SZWBTOXbS1YMj7qIZVsqXN8eItn3QcV2GqnNf6d5oNIX3sh9U6kAbN6sBK0AvrsyWMYTZnTU0ziG62RrFV4YXmcAInIxRuWg-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4906A871.6010501@schaufler-ca.com>
Date: Mon, 27 Oct 2008 22:51:45 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Rob MacKinnon <c4blem0nkey@gmail.com>
CC: Andreas Gruenbacher <agruen@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>,
       rob.mackinnon@gmail.com, hpa@zytor.com, hugh@veritas.com,
       linux-kernel@vger.kernel.org, casey@schaufler-ca.com
Subject: Re: tmpfs support of xattrs?
References: <4902DD98.4090302@gmail.com> <4906211E.8030603@gmail.com> <1225139131.31818.51.camel@moss-spartans.epoch.ncsc.mil> <200810272153.56301.agruen@suse.de> <49062EC0.4040809@gmail.com>
In-Reply-To: <49062EC0.4040809@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob MacKinnon wrote:
> Andreas Gruenbacher wrote:
>   
>> On Monday, 27 October 2008 21:25:31 Stephen Smalley wrote:
>>     
>>> Looks like a bug in Smack's implementation of the inode_listsecurity
>>> hook to me.  Did you mean to enable Smack in your kernel config?
>>>       
>> Yes, there is at least one bug there; this kernel is broken. You may want to 
>> try booting with a kernel command line option like "security=none", which 
>> *should* turn smack off.
>>
>> Andreas
>>     
>
> All,
>
> Indeed the kernel cmdline option security=none did disable smack. So
> atleast that works. Thank you all for helping me track this down.  I can
> now return to updating packages (some of which have been waiting
> patiently for this to be cleared up)!  Though I will be looking forward
> to this feature working as it was intended. ;)  Let me know if there is
> a bug # assigned and I'll quietly return to lurking... ;

It looks like a trivial fix and the patch is here. I have just started
testing it myself, but if I don't send it now it will be Wednesday before
I do. No sign-off because I haven't verified it, but I would be delighted
if you would pass judgement on its efficacy. Thank you.


----

diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6/security/smack/smack_lsm.c linux-smack/security/smack/smack_lsm.c
--- linux-2.6/security/smack/smack_lsm.c	2008-10-26 17:37:08.000000000 -0700
+++ linux-smack/security/smack/smack_lsm.c	2008-10-26 19:11:23.000000000 -0700
@@ -763,13 +763,11 @@ static int smack_inode_getsecurity(const
 static int smack_inode_listsecurity(struct inode *inode, char *buffer,
 				    size_t buffer_size)
 {
-	int len = strlen(XATTR_NAME_SMACK);
+	int len = sizeof(XATTR_NAME_SMACK);
 
-	if (buffer != NULL && len <= buffer_size) {
+	if (buffer != NULL && len <= buffer_size)
 		memcpy(buffer, XATTR_NAME_SMACK, len);
-		return len;
-	}
-	return -EINVAL;
+	return len;
 }
 
 /**

