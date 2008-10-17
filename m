Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYJQOcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYJQOcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYJQOb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:31:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35460 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbYJQOb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:31:58 -0400
Date: Fri, 17 Oct 2008 12:33:01 -0200
From: Glauber Costa <glommer@redhat.com>
To: Max Kellermann <mk@cm4all.com>
Cc: linux-kernel@vger.kernel.org, gcosta@redhat.com, ijc@hellion.org.uk
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
Message-ID: <20081017143301.GA18522@poweredge.glommer>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017123207.GA14979@rabbit.intern.cm-ag>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 02:32:07PM +0200, Max Kellermann wrote:
> Hi,
> 
> Ian: this is a follow-up to your post "NFS regression? Odd delays and
> lockups accessing an NFS export" a few weeks ago
> (http://lkml.org/lkml/2008/9/27/42).
> 
> I am able to trigger this bug within a few minutes on a customer's
> machine (large web hoster, a *lot* of NFS traffic).
> 
> Symptom: with 2.6.26 (2.6.27.1, too), load goes to 100+, dmesg says
> "INFO: task migration/2:9 blocked for more than 120 seconds." with
> varying task names.  Except for the high load average, the machine
> seems to work.
> 
> With git bisect, I was finally able to identify the guilty commit,
> it's not "Ensure we zap only the access and acl caches when setting
> new acls" like you guessed, Ian.  According to my bisect,
> 6becedbb06072c5741d4057b9facecb4b3143711 is the origin of the problem.
> e481fcf8563d300e7f8875cae5fdc41941d29de0 (its parent) works well.
> 
> Glauber: that is your patch "x86: minor adjustments for do_boot_cpu"
> (http://lkml.org/lkml/2008/3/19/143).  I don't understand this patch
> well, and I fail to see a connection with the symptom, but maybe
> somebody else does...
> 
> See patch below (applies to 2.6.27.1).  So far, it looks like the
> problem is solved on the server, no visible side effects.
> 
> Max
That's probably something related to apic congestion.
Does the problem go away if the only thing you change is this:


> @@ -891,11 +897,6 @@ do_rest:
>  		store_NMI_vector(&nmi_high, &nmi_low);
>  
>  		smpboot_setup_warm_reset_vector(start_ip);
> -		/*
> -		 * Be paranoid about clearing APIC errors.
> -	 	*/
> -		apic_write(APIC_ESR, 0);
> -		apic_read(APIC_ESR);
>  	}


Please let me know.

