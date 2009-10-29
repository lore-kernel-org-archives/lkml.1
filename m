Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbZJ2PJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbZJ2PJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZJ2PJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:09:36 -0400
Received: from mail.solarflare.com ([216.237.3.220]:33610 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbZJ2PJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:09:35 -0400
Subject: Re: Shared i2c adapter locking (Was: linux-next: manual merge of
	the net tree with the i2c tree)
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
In-Reply-To: <20091029154317.651904b9@hyperion.delvare>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
	 <20091029154317.651904b9@hyperion.delvare>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Thu, 29 Oct 2009 15:09:36 +0000
Message-Id: <1256828976.2827.27.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2009 15:09:40.0436 (UTC) FILETIME=[D6779940:01CA58A9]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.600.1016-16976.003
X-TM-AS-Result: No--40.810900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 15:43 +0100, Jean Delvare wrote:
> Hi Stephen,
> 
> On Mon, 26 Oct 2009 13:37:57 +1100, Stephen Rothwell wrote:
> > Today's linux-next merge of the net tree got a conflict in
> > drivers/net/sfc/sfe4001.c between commit
> > 3f7c0648f727a6d5baf6117653e4001dc877b90b ("i2c: Prevent priority
> > inversion on top of bus lock") from the i2c tree and commit
> > c9597d4f89565b6562bd3026adbe6eac6c317f47 ("sfc: Merge sfe4001.c into
> > falcon_boards.c") from the net tree.
> > 
> > I have applied the following merge fixup patch (after removing
> > drivers/net/sfc/sfe4001.c) and can carry it as necessary.
> 
> Thanks for fixing it. The core problem here IMHO is that the sfc
> network driver touches i2c internals which it would rather leave alone.

I'm just a little proud of having the idea that we could avoid using an
I/O-expander on this board, but yes, the software side of this
multiplexing is a hack.

> This is the only driver I know of which does this.
> 
> I can think of 3 different ways to address the issue.
> 
> Method #1: add a public API to grab/release an I2C segment.
> 
> void i2c_adapter_lock(struct i2c_adapter *adapter)
> {
> 	rt_mutex_lock(&adapter->bus_lock);
> }
> 
> void i2c_adapter_unlock(struct i2c_adapter *adapter)
> {
> 	rt_mutex_unlock(&adapter->bus_lock);
> }
[...]
> I'm not really sure if I have a preference yet, so please speak up if
> you do.

Indirect lock operations are a recipe for deadlock, and there doesn't
seem to be any other user for this, so method 1 seems best.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

