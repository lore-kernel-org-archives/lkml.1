Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbXIYBmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbXIYBmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 21:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXIYBme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 21:42:34 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:32675 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbXIYBmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 21:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Dw4LHqIxtYg8lhe5E6Hd/1iShYVLDANljnOVeuvY6LiqDLCtkKbmkjuqvlDV/o1Fh1FRmdiUEs4YEZssYhVa8G8S7gS4m9cAMUJQkwO16aXCH5oowgagihSl+wRtA0+SIo8hDGGaAxbos8lP2ODK+IH+MgLuClkXL9zfkGcRKNs=
Message-ID: <46F86727.4050004@gmail.com>
Date: Tue, 25 Sep 2007 10:40:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
References: <25380.1190671205@lwn.net>  <46F845B2.7030002@gmail.com> <1190677332.27805.229.camel@localhost.localdomain>
In-Reply-To: <1190677332.27805.229.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 2007-09-25 at 08:18 +0900, Tejun Heo wrote:
>>> Given your description of this tool as a "sledgehammer," might it not be
>>> easier to just take and hold module_mutex for the duration of the unload
>>> block?
>> That would be easier but...
>>
>> * It would serialize users of the sledgehammer.
>> * It would block loading modules (which is often more important than
>> unloading them) when things go south.
> 
> My concern is that you're dropping the module mutex around ->exit now.
> I don't *think* this should matter, but it's worth considering.

We always did that.  Before the patch the code segment looked like the
following.

	/* Final destruction now noone is using it. */
	if (mod->exit != NULL) {
		mutex_unlock(&module_mutex);
		mod->exit();
		mutex_lock(&module_mutex);
	}	

> I really wonder if an explicit "kill_this_attribute()" is a better way
> to go than this...

I think this sort of temporary unload blocking would be useful for other
cases like this.

Thanks.

-- 
tejun
