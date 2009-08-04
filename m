Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZHDOWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZHDOWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbZHDOWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:22:53 -0400
Received: from ru.mvista.com ([213.79.90.228]:46457 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754569AbZHDOWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:22:53 -0400
Date: Tue, 4 Aug 2009 18:22:50 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: Ang: Re: [PATCH 0/2] Setting GPIOs simultaneously
Message-ID: <20090804142250.GA17398@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090713222005.GA19859@oksana.dev.rtsoft.ru>
 <20090713151911.GA28114@oksana.dev.rtsoft.ru>
 <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@transmode.se>
 <20090713173455.GA9866@oksana.dev.rtsoft.ru>
 <OF9378E65D.FBBCCFD5-ONC12575F2.006B28D5-C12575F2.006DDAE5@transmode.se>
 <OF613F53BF.1FD77EDB-ONC12575F3.00753535-C12575F3.00753537@transmode.se>
 <20090714220931.GA11378@oksana.dev.rtsoft.ru>
 <OF9A2BDEDE.DC0DE0D4-ONC1257608.004A7A59-C1257608.004AF3BF@transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <OF9A2BDEDE.DC0DE0D4-ONC1257608.004A7A59-C1257608.004AF3BF@transmode.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 03:38:40PM +0200, Joakim Tjernlund wrote:
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote on 15/07/2009 00:09:31:
> >
> > On Tue, Jul 14, 2009 at 11:20:13PM +0200, Joakim Tjernlund wrote:
> > [...]
> > > >But any users of the legacy bindings should be in-tree.
> > >
> > > ehh, it was working until you made it OF only. Why do call the native
> > > way legacy?  It is the method all non OF arch uses.
> >
> > It's legacy because there are no in-tree users anymore. Nowadays
> > we're trying to pass all needed information via OF, and we're
> > trying to avoid ugly platform-dependant hacks. Your SPI scheme
> > can be easily described via OF, but sure, it's hard to implement
> > it with the current SPI/OF subsystem.
> 
> Sorry for the long delay, I have been on vaction and been busy with other stuff.
> 
> Tell me, how does this new OF SPI device scheme work out if you want
> to use the bitbanged SPI driver?

spi-controller {
	...
	compatible = "generic-bitbang-spi";
	gpios = <GPIO_CLK GPIO_MOSI GPIO_MISO>;
	spi,chip-select-machines = <&gpio_csm &board_csm>;

	gpio_csm: chip-select-machine {
		#address-cells = <1>;
		#size-cells = <0>;
		compatible = "generic-gpio-csm";
		gpios = <GPIO_CS1 GPIO_CS2>;

		touchscreen@0 {
			reg = <0>; /* using GPIO CS1 */
		};

		eeprom@1 {
			reg = <1>; /* using GPIO CS2 */
		};
	};
};

localbus {
	...
	board_csm: chip-select-machine {
		#address-cells = <1>;
		#size-cells = <0>;
		compatibe = "board-specific-csm";

		light-sensor@0 {
			reg = <0>; /* using board-specific "CS3" */
		};

		battery@1 {
			reg = <1>; /* using board-specific "CS4" */
		};
	};
};

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
