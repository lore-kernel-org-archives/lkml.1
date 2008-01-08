Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYAHGRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYAHGRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 01:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbYAHGRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 01:17:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:37026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbYAHGRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 01:17:00 -0500
From: Neil Brown <neilb@suse.de>
To: Jeff Layton <jlayton@redhat.com>
Date: Tue, 8 Jan 2008 17:16:52 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18307.5460.45538.800941@notabene.brown>
Cc: akpm@linux-foundation.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] NLM: Convert lockd to use kthreads
In-Reply-To: message from Jeff Layton on Saturday January 5
References: <1199534542-3384-1-git-send-email-jlayton@redhat.com>
	<1199534542-3384-2-git-send-email-jlayton@redhat.com>
	<1199534542-3384-3-git-send-email-jlayton@redhat.com>
	<1199534542-3384-4-git-send-email-jlayton@redhat.com>
	<1199534542-3384-5-git-send-email-jlayton@redhat.com>
	<1199534542-3384-6-git-send-email-jlayton@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday January 5, jlayton@redhat.com wrote:
> Have lockd_up start lockd using kthread_run. With this change,
> lockd_down now blocks until lockd actually exits, so there's no longer
> need for the waitqueue code at the end of lockd_down. This also means
> that only one lockd can be running at a time which simplifies the code
> within lockd's main loop.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---


> -	module_put_and_exit(0);
> +	module_put(THIS_MODULE);
> +	return 0;

This changes bothers me.  Putting the last ref to a module in code
inside that module is not safe, which is why module_put_and_exit
exists. 

So this module_put is either unsafe or not needed.  I think the
latter.

As you say in the comment, lockd_down now blocks until lockd actually
exits.  As every caller for lockd_down will own a reference to the
lockd module, the lockd thread no longer needs to own a reference too.
So I think it is safe to remove the module_put, and also remove the
__module_get at the top of the lockd function.

Also, I suspect that the "no users" and "no lockd running" messages
should probably be changed to BUGs as they really should be
impossible, not just unlikely.

Also:

> 	 * Check whether there's a new lockd process before
> 	 * shutting down the hosts and clearing the slot.
> 	 */

This comment should go as the actual check has gone.

The rest looks fine. It is a substantial improvement, thanks.

NeilBrown
