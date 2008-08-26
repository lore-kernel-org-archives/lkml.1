Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYHZTxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYHZTxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYHZTxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:53:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYHZTxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:53:34 -0400
Message-ID: <48B45F16.7080203@zytor.com>
Date: Tue, 26 Aug 2008 12:52:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Gerhard Brauer <gerhard.brauer@web.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
References: <20080822132948.57e47076@doriath.conectiva> <20080822163520.GA9860@Krystal> <20080822142054.403cbdef@doriath.conectiva> <20080822175741.6bc83dc8@doriath.conectiva> <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva> <20080826171822.GB14906@Krystal> <20080826150222.0cf1542c@doriath.conectiva> <20080826181558.GA16887@Krystal>
In-Reply-To: <20080826181558.GA16887@Krystal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One thing that I think really needs to be considered is that the current 
PV stubs are (a) large, and (b) non-atomic.

In the case at hand we have:

c012fc69:       51                      push   %ecx
c012fc6a:       52                      push   %edx
c012fc6b:       ff 15 40 b9 41 c0       call   *0xc041b940
c012fc71:       5a                      pop    %edx
c012fc72:       59                      pop    %ecx

Ten bytes replacing a two-byte native sequence.

If this was done as a call to an out-of-line stub, it would be only five 
bytes, which would reduce native icache overhead from 400% to 150%, but 
perhaps more importantly, it would not be subject to returns inside the 
sequence itself (since the out-of-line stub would still exist.)  As an 
optional bonus, at least on 32 bits the indirect call could be replaced 
with a direct call in the out-of-line stub.

	-hpa
