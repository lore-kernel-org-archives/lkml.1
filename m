Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbYIYPAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbYIYPAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbYIYO7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:59:49 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47646 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbYIYO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:59:49 -0400
Date: Thu, 25 Sep 2008 09:59:30 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, serue@linux.vnet.ibm.com,
       zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
       debora@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] TPM: rcu locking
Message-ID: <20080925145930.GA20055@us.ibm.com>
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com> <1222190371-23814-3-git-send-email-srajiv@linux.vnet.ibm.com> <20080923181922.GE6637@linux.vnet.ibm.com> <1222201097.24276.12.camel@blackbox> <20080923202701.GF6637@linux.vnet.ibm.com> <20080925133645.GB13414@us.ibm.com> <20080925143312.GE6725@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925143312.GE6725@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul E. McKenney (paulmck@linux.vnet.ibm.com):
> On Thu, Sep 25, 2008 at 08:36:45AM -0500, Serge E. Hallyn wrote:
> > Quoting Paul E. McKenney (paulmck@linux.vnet.ibm.com):
> > > On Tue, Sep 23, 2008 at 05:18:17PM -0300, Rajiv Andrade wrote:
> > > > Paul,
> > > > 
> > > > On Tue, 2008-09-23 at 11:19 -0700, Paul E. McKenney wrote:
> > > > > 
> > > > > But here we are deleting from what appears to be some other list.
> > > > > And I don't see any insertiong into either list.
> > > > > 
> > > > > What am I missing here?
> > > > > 
> > > > >                                                         Thanx, Paul
> > > > 
> > > > Sorry, forgot to change list_add() to list_add_rcu() in the code section
> > > > below:
> > > > 
> > > > > > +     /* Make chip available */
> > > > > > +     spin_lock(&driver_lock);
> > > > > > +     list_add(&chip->list, &tpm_chip_list);
> > > > > > +     spin_unlock(&driver_lock);
> > > > 
> > > > I'll resubmit.
> > > 
> > > Cool!
> > > 
> > > So tpm_chip_list and the not-obviously-identical list manipulated
> > > in tpm_remove_hardware() really are the same list?
> > > 
> > > 							Thanx, Paul
> > 
> > Hey Paul,
> > 
> > curious, why do they not look like the same list?
> 
> Because one of them is named &tpm_chip_list, a global variable, and the
> other seemed to be returned from a function taking a struct device as an
> argument.  This is indeed consistent with an element in this list being
> hung off of the struct device, so perhaps I was just being insufficiently
> persistent in tracking things down.
> 
> 							Thanx, Paul

Right, tpm_register_hardware both does
	dev_set_drvdata(dev, chip)
to set dev->driver_data = chip, and list_add(chip->list, &tpm_chip_list).
The tpm_remove_hardware(), then, gets the device, gets the chip from
dev->driver_data,  and removes it from the tpm_chip_list.

It does look kosher.

Though once this is all applied to some public git tree, I want to take
some time to look at the full result.

-serge
