Return-Path: <linux-kernel-owner+w=401wt.eu-S937289AbYBWI1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937289AbYBWI1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbYBWIKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:10:22 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932541AbYBWIKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:10:19 -0500
Date: Sat, 23 Feb 2008 00:05:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/6] regulator: consumer driver regulator control
 framework.
Message-Id: <20080223000528.c01e1b51.akpm@linux-foundation.org>
In-Reply-To: <1203527333.4071.89.camel@localhost.localdomain>
References: <1203527333.4071.89.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 17:08:53 +0000 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:

> This framework provides voltage and current regulator control to allow
> consumer drivers to control their supply voltages and current levels.
> 
> The framework is similar to the kernel clock interface in that client or
> consumer drivers can get() and put() a regulator (like they can with clocks
> atm).
> 
> Consumers can also get() or set() :- voltage, current, operating mode.
> Consumers can also enable and disable regulators.
> 
> The framework also compiles out if not in use so drivers can be reused in
> systems with no software PMIC power control.
> 
> ...
>
> +#define REGULATOR_MODE_FAST			0x1
> +#define REGULATOR_MODE_NORMAL			0x2
> +#define REGULATOR_MODE_IDLE			0x4
> +#define REGULATOR_MODE_STANDBY			0x8

The values which you chose here would imply that these values can be ORed
together.  But they can't can they?

If not, plain old 0,1,2,3 would be clearer.

We often use enums for this sort of thing.

> +/*
> + * Regulator notifier events.
> + *
> + * @UNDER_VOLTAGE:  Regulator output is under voltage.
> + * @OVER_CURRENT:   Regulator output current is too high.
> + * @POWER_ON:       Regulator power ON event.
> + * @POWER_OFF:      Regulator power OFF event.
> + * @REGULATION_OUT: Regulator output is out of regulation.
> + * @FAIL:           Regulator output has failed.
> + * @OVER_TEMP:      Regulator over temp.
> + */

The above makes it look like this is a kerneldoc comment, but it isn't.

> +#define REGULATOR_EVENT_UNDER_VOLTAGE		0x1
> +#define REGULATOR_EVENT_OVER_CURRENT		0x2
> +#define REGULATOR_EVENT_POWER_ON		0x4
> +#define REGULATOR_EVENT_POWER_OFF		0x8
> +#define REGULATOR_EVENT_REGULATION_OUT		0x10
> +#define REGULATOR_EVENT_FAIL			0x20
> +#define REGULATOR_EVENT_OVER_TEMP		0x40

These I assume _can_ legitimately be ORed together.

These also could be a enum.

> +/*
> + * Convenience conversion.
> + * Here atm, maybe there is somewhere better for this.
> + */
> +#define mV_to_uV(mV)	(mV * 1000)
> +#define uV_to_mV(uV)	(uV / 1000)
> +#define V_to_uV(V)	(mV_to_uV(V * 1000))
> +#define uV_to_V(uV)	(uV_to_mV(uV) / 1000)
> +#define mA_to_uA(mA)	(mA * 1000)
> +#define uA_to_mA(uA)	(uA / 1000)
> +#define A_to_uA(A)	(mA_to_uA(A * 1000))
> +#define uA_to_A(uA)	(uA_to_mA(uA) / 1000)

hm.  It might be nicer to make these static inline functions.  Especially
if the code is consistent about what C type is used to represent voltage
and current.


> +struct regulator;
> +
> +#if defined (CONFIG_REGULATOR)
> +
> +/**
> + * regulator_get - lookup and obtain a reference to a regulator.
> + * @dev: device for regulator "consumer"
> + * @id: regulator ID
> + *
> + * Returns a struct regulator corresponding to the regulator producer, or
> + * IS_ERR() condition containing errno.
> + */
> +struct regulator * __must_check regulator_get(struct device *dev,
> +	const char *id);

We conventionally put the kerneldoc at the definition site, not at the
declaration site.

> +/**
> + * regulator_put - "free" the regulator source
> + * @regulator: regulator source
> + *
> + * Note: drivers must ensure that all regulator_enable calls made on this
> + * regulator source are balanced by regulator_disable calls prior to calling
> + * this function.
> + */
> +void regulator_put(struct regulator *regulator);
> +
> +/**
> + * regulator_enable - enable regulator output
> + * @regulator: regulator source
> + *
> + * Enable the regulator output at the predefined voltage or current value.
> + * NOTE: the output value can be set by other drivers, bootloader or may be
> + * hardwired in the regulator.
> + */
> +int regulator_enable(struct regulator *regulator);
> +
> +/**
> + * regulator_disable - disable regulator output
> + * @regulator: regulator source
> + *
> + * Disable the regulator output voltage or current.
> + * NOTE: this will only disable the regulator output iff no other consumer
> + * devices have it enabled.
> + */
> +int regulator_disable(struct regulator *regulator);
> +
> +/**
> + * regulator_is_enabled - is the regulator output enabled
> + * @regulator: regulator source
> + *
> + * Returns zero for disabled otherwise return number of enable requests.
> + */
> +int regulator_is_enabled(struct regulator *regulator);
> +
> +/**
> + * regulator_set_voltage - set regulator output voltage
> + * @regulator: regulator source
> + * @uV: voltage in uV
> + *
> + * Sets a voltage regulator to the desired output voltage. This can be set
> + * during any regulator state. IOW, regulator can be disabled or enabled.
> + *
> + * If the regulator is enabled then the voltage will change to the new value
> + * immediately otherwise if the regulator is disabled the regulator will
> + * output at the new voltage when enabled.
> + *
> + * NOTE: If the regulator is shared between several devices then the lowest
> + * request voltage that meets the system constraints will be used.
> + * NOTE: Regulator system constraints must be set for this regulator before
> + * calling this function otherwise this call will fail.
> + */
> +int regulator_set_voltage(struct regulator *regulator, int uV);
> +
> +/**
> + * regulator_get_voltage - get regulator output voltage
> + * @regulator: regulator source
> + *
> + * This returns the current regulator voltage in uV.
> + *
> + * NOTE: If the regulator is disabled it will return the voltage value. This
> + * function should not be used to determine regulator state.
> + */
> +int regulator_get_voltage(struct regulator *regulator);
> +
> +/**
> + * regulator_set_current - set regulator output current for a current sink
> + * @regulator: regulator source
> + * @uA: current in uA
> + *
> + * Sets current sink to the desired output current. This can be set during
> + * any regulator state. IOW, regulator can be disabled or enabled.
> + *
> + * If the regulator is enabled then the current will change to the new value
> + * immediately otherwise if the regulator is disabled the regulator will
> + * output at the new current when enabled.
> + *
> + * NOTE: Regulator system constraints must be set for this regulator before
> + * calling this function otherwise this call will fail.
> + */
> +int regulator_set_current(struct regulator *regulator, int uA);
> +
> +/**
> + * regulator_get_current - get regulator output current
> + * @regulator: regulator source
> + *
> + * This returns the current supplied by the specified current sink in uA.
> + *
> + * NOTE: If the regulator is disabled it will return the current value. This
> + * function should not be used to determine regulator state.
> + */
> +int regulator_get_current(struct regulator *regulator);
> +
> +/**
> + * regulator_set_mode - set regulator operating mode
> + * @regulator: regulator source
> + * @mode: operating mode - one of the REGULATOR_MODE constants
> + *
> + * Set regulator operating mode to increase regulator efficiency or improve
> + * regulation performance.
> + *
> + * NOTE: Regulator system constraints must be set for this regulator before
> + * calling this function otherwise this call will fail.
> + */
> +int regulator_set_mode(struct regulator *regulator, unsigned int mode);
> +
> +/**
> + * regulator_get_mode - set regulator operating mode

s/set/get/

> + * @regulator: regulator source
> + *
> + * Get the current regulator operating mode.
> + */
> +unsigned int regulator_get_mode(struct regulator *regulator);
> +
> +/**
> + * regulator_get_optimum_mode - get regulator optimum operating mode
> + * @regulator: regulator source
> + * @input_uV: input voltage
> + * @output_uV: output voltage
> + * @load_uV: load current
> + *
> + * Get the most efficient regulator operating mode for the given input
> + * and output voltages at a specific load..
> + */
> +unsigned int regulator_get_optimum_mode(struct regulator *regulator,
> +	int input_uV, int output_uV, int load_uA);
> +
> +/**
> + * regulator_register_client - register regulator event notifier
> + * @regulator: regulator source
> + * @notifier_block: notifier block
> + *
> + * Register notifier block to receive regulator events.
> + */
> +int regulator_register_client(struct regulator *regulator,
> +	struct notifier_block *nb);
> +
> +/**
> + * regulator_unregister_client - unregister regulator event notifier
> + * @regulator: regulator source
> + * @notifier_block: notifier block
> + *
> + * Unregister regulator event notifier block.
> + */
> +int regulator_unregister_client(struct regulator *regulator,
> +	struct notifier_block *nb);
> +
> +/**
> + * regulator_notify_load - notify regulator of new device load
> + * @regulator: regulator
> + * @dev: device
> + * @uA: load
> + *
> + * Notifies the regulator core of a new device load. This is then used by
> + * DRMS (if enabled by constraints) to select the most efficient regulator
> + * operating mode for the new regulator loading.
> + *
> + * Client devices notify their supply regulator of the maximum power
> + * they will require (can be taken from device datasheet in the power
> + * consumption tables) when they change operational status and hence power
> + * state. Examples of operational state changes that can affect power
> + * consumption are :-
> + *
> + *    o Device is opened / closed.
> + *    o Device I/O is about to begin or has just finished.
> + *    o Device is idling in between work.
> + *
> + * This information is also exported via sysfs to userspace.

Is the sysfs interface documented in here somewhere so we can review it?

Greg like sysfs stuff to be documented in Documentation/ABI

> + * DRMS would then sum the total requested load on the regulator and change
> + * to the most efficient operating mode if platform constraints allow.
> + */
> +void regulator_drms_notify_load(struct regulator *regulator, int uA);
> +
> +/**
> + * regulator_get_drvdata - get regulator driver data
> + * @regulator: regulator
> + */
> +void *regulator_get_drvdata(struct regulator *regulator);
> +
> +/**
> + * regulator_set_drvdata - get regulator driver data
> + * @regulator: regulator
> + * @data: data
> + */
> +void regulator_set_drvdata(struct regulator *regulator, void *data);
> +
> +#else
> +
> +/*
> + * Make sure client drivers will still build on systems with no software
> + * controllable voltage or current regulators.
> + */
> +#define regulator_get(dev, id)	({ (void)(dev); (void)(id); NULL; })
> +#define regulator_put(regulator) do { (void)(regulator);} while (0)
> +#define regulator_enable(regulator) ({ (void)(regulator); 0; })
> +#define regulator_disable(regulator) ({ (void)(regulator); 0; })
> +#define regulator_is_enabled(regulator) ({ (void)(regulator); 1; })
> +#define regulator_set_voltage(regulator, uV) \
> +	({ (void)(regulator); (void)(uV); 0; })
> +#define regulator_get_voltage(regulator) ({ (void)(regulator); 0; })
> +#define regulator_set_current(regulator, uA) \
> +	({ (void)(regulator); (void)(uA); 0; })
> +#define regulator_get_current(regulator) ({ (void)(regulator); 0; })
> +#define regulator_set_mode(regulator, mode) \
> +	({ (void)(regulator); (void)(mode); 0; })
> +#define regulator_get_mode(regulator) ({ (void)(regulator); 0; })
> +#define regulator_get_optimum_mode(regulator, input_uV, output_uV, load_uA) \
> +	({ (void)(regulator); (void)(input_uV); (void)(output_uV);\
> +		(void)(load_uA); 0; })
> +#define regulator_register_client(regulator, nb) \
> +	({ (void)(regulator); (void)(nb); 0; })
> +#define regulator_unregister_client(regulator, nb) \
> +	do { (void)(regulator); (void)(nb);} while (0)
> +#define regulator_notify_load(regulator, dev, uA) \
> +	do { (void)(regulator); (void)(dev); (void)(uA);} while (0)
> +#define regulator_get_drvdata(regulator) ({ (void)(regulator); NULL; })
> +#define regulator_set_drvdata(regulator, data) \
> +	do { (void)(regulator); (void)(data);} while (0)
> +

I think you'll find that all these can be implemented more nicely as static
inlines.

