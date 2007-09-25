Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXIYI1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXIYI1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXIYI0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:26:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:17502 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbXIYI0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dWez6HFLIeTHTd32CuskvxpfyNX01jnH+QcngEeghrHFVdXEhGftlGfzQ6fGmMKPblZU7ftAQdsBEIlHQ8Wqv5qsdhG4snHHvL9R75dprvacSGP6nEs15iI5iUbQpnbgWKUfMivZwWyTz78XSnyJ+XYeLICalGdsOwI7OAWFtCc=
Message-ID: <46F8C5ED.6060101@gmail.com>
Date: Tue, 25 Sep 2007 17:25:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
References: <25380.1190671205@lwn.net>  <46F845B2.7030002@gmail.com>	 <1190677332.27805.229.camel@localhost.localdomain>	 <46F86727.4050004@gmail.com>	 <1190686320.27805.258.camel@localhost.localdomain>	 <46F874DB.5070205@gmail.com>	 <1190690493.27805.263.camel@localhost.localdomain>	 <46F8822D.2010003@gmail.com> <1190695118.27805.307.camel@localhost.localdomain>
In-Reply-To: <1190695118.27805.307.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 2007-09-25 at 12:36 +0900, Tejun Heo wrote:
>> Rusty Russell wrote:
>>> As stated you cannot protect arbitrary code this way, as you are trying
>>> to do.  I do not think you've broken any of the current code, but I
>>> cannot tell.  You're certainly going to surprise unsuspecting future
>>> authors.
>> Can you elaborate a bit?  Why can't it protect the code?
> 
> Because you don't know what that code does.  After all, it's assumed
> that module code doesn't get called after exit and you're deliberately
> violating that assumption.

What I meant by protecting 'code' was the 'code' itself.  Those pages
containing instructions that cpu executes.  It of course can't protect
against all the things they do.

>>> Can you really not figure out the module owner of the sysfs entry to inc
>>> its use count during this procedure?  (__module_get()).
>> I can but I don't think it's worth the effort.  It will involve passing
>> @owner parameter down through kobject to sysfs but the path is pretty
>> obscure and thus difficult to test.
> 
> Have you tested that *this* path works?  Let's take your first change as
> an example:
> 
> +       mutex_lock(&gdev->reg_mutex);
> +       __ccwgroup_remove_symlinks(gdev);
> +       device_unregister(dev);
> +       mutex_unlock(&gdev->reg_mutex);
> 
> Now, are you sure that calling cleanup_ccwgroup just after
> device_unregister() works?
> 
> static void __exit
> cleanup_ccwgroup (void)
> {
> 	bus_unregister (&ccwgroup_bus_type);
> }

It should.  After ->exit() is called, there can't be any object left
behind.  If a module is hosting objects which can't be destroyed from
->exit(), its module ref count shouldn't be zero.  So, either 1.
refcount != 0 or 2. ->exit() can destroy all objects.  As Cornelia
explains, for ccwgroup, it's #1.  Note that unload inhibition doesn't
change anything about this.

>> I think it's too much work for the
>> users of the API and it will be easy to pass the wrong @owner and go
>> unnoticed.
> 
> But your shortcut insists that all module authors be aware that
> functions can be running after exit() is called.  That's a recipe for
> instability and disaster.

No, it doesn't change that at all.  All unload inhibition does is
postponing removal of code (and data too of course) section a bit so
that a module can host code which issues unloading of itself.  Object
synchronization rules remain exactly the same.  Formerly broken code is
still broken and I don't even think unload inhibition would mask them
too much either.

I think the naming is too ambiguous.  Maybe it should be named something
like "hold_module_for_suicide".

Thanks.

-- 
tejun
